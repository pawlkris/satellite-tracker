class SatelliteRecord < ApplicationRecord
  before_create :set_average
  before_create :set_minute_below

  def set_average
    self.average = SatelliteRecord.average(self.altitude)
  end

  def set_minute_below
    self.minute_below = SatelliteRecord.minute_below?(self)
  end

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

end
