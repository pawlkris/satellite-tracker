class SatelliteRecord < ApplicationRecord

  def self.fetch
    # actually fetching the data and parsing to json
    url = "nestio.space/api/satellite/data"
    headers = {Accept:'application/json'}
    response = RestClient.get(url, headers)
    json = JSON.parse(response)
    # pulling variables from json for ease of reading code
    altitude = json["altitude"]
    time = DateTime.strptime(json["last_updated"],"%Y-%m-%dT%H:%M:%S")
    # call average method to set average
    average = SatelliteRecord.average(altitude)
    # if last six records averages were below 160, set minute_below to true
    minute_below = SatelliteRecord.minute_below?
    # create object
    SatelliteRecord.create(altitude:altitude, last_updated:time, average:average, minute_below:minute_below)
  end

  def self.average(current)
    # pull altitudes for past 30 records/5min
    altitudes_for_average = SatelliteRecord.last(30).map{|record| record.altitude}
    # add altitude from record being added (time 0)
    altitudes_for_average.push(current)
    # calculate average
    average = altitudes_for_average.sum/altitudes_for_average.length
  end

  def self.minute_below?
    # check if all record averages in the past minute were below 160
    self.all.last(6).all?{|x|x.average < 160}
  end

  def self.message
    # if records from the past minute all have an average below 160
    if SatelliteRecord.last.minute_below
      return {message: 'WARNING: RAPID ORBITAL DECAY IMMINENT'}
    # if at leaste one record in the past minute has an average below 160
    elsif (SatelliteRecord.all.last(7).find{|record| record.minute_below==true} &&   SatelliteRecord.all.last(7).find{|record| record.average > 160})
      return {message: "Sustained Low Earth Orbit Resumed"}
    # otherwise, the 5-min average for the last 5 records will be above 160 and all is good
    else #SatelliteRecord.all.last(6).all?{|x| x.average > 160}
      return {message: "Altitude is A-OK"}
    end
  end



end
