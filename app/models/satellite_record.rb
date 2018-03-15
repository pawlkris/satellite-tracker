class SatelliteRecord < ApplicationRecord
  before_create :set_average
  before_create :set_minute_below


  def set_average
    self.average = SatelliteRecord.average(self.altitude)
  end

  def set_minute_below
    self.minute_below = SatelliteRecord.minute_below?(self)
  end

  # def self.fetch
  #   url = "nestio.space/api/satellite/data"
  #   headers = {Accept:'application/json'}
  #   response = RestClient.get(url, headers)
  #   json = JSON.parse(response)
  #   altitude = json["altitude"]
  #   time = DateTime.strptime(json["last_updated"],"%Y-%m-%dT%H:%M:%S")
  #   SatelliteRecord.create(altitude:altitude, last_updated:time)
  # end

  def self.average(current)
    altitudes_for_average = SatelliteRecord.last(30).map{|record| record.altitude}
    altitudes_for_average.push(current)
    average = altitudes_for_average.sum/altitudes_for_average.length
  end

  def self.minute_below?(current)
    length = self.all.length
    if length < 6
      return false
    end
    self.all.last(6).push(current).all?{|x|x.average < 160}
  end

  def self.message
    if SatelliteRecord.last.minute_below
      return {message: 'WARNING: RAPID ORBITAL DECAY IMMINENT'}
    elsif (SatelliteRecord.all.last(7).find{|record| record.minute_below==true} &&   SatelliteRecord.all.last(7).find{|record| record.average > 160})
      return {message: "Sustained Low Earth Orbit Resumed"}
    else
      return {message: "Altitude is A-OK"}
    end
  end



end
