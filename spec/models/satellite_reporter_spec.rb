require 'rails_helper'

RSpec.describe SatelliteReporter, type: :model do


  describe "SatelliteReporter.health" do
    it "returns 'WARNING: RAPID ORBITAL DECAY IMMINENT' when previous 7 records' averages are below 160, thus making the last record's minute_below status true" do
      7.times {|i| SatelliteRecord.create(altitude: 120, last_updated:"2018-03-13 13:16:00")}
      SatelliteRecord.create(altitude: 120.757129951577, last_updated:"2018-03-13 13:16:00")
      reporter = SatelliteReporter.new
      expect(reporter.health).to eq({:message=>"WARNING: RAPID ORBITAL DECAY IMMINENT"} )
    end
    it "returns 'WARNING: RAPID ORBITAL DECAY IMMINENT' when previous 6 records' averages are below 160" do
      6.times {|i| SatelliteRecord.create(altitude: 120, last_updated:"2018-03-13 13:16:00")}
      SatelliteRecord.create(altitude: 120.757129951577, last_updated:"2018-03-13 13:16:00")
      reporter = SatelliteReporter.new
      expect(reporter.health).to eq({:message=>"WARNING: RAPID ORBITAL DECAY IMMINENT"} )
    end


    it "returns 'Sustained Low Earth Orbit Resumed' when at least one of the past seven records' altitudes is above 160 at least one record's minute_below? status is true" do
      7.times{|i| SatelliteRecord.create(altitude: 158.757129951577, last_updated:"2018-03-13 13:16:00")}
      1.times{|i| SatelliteRecord.create(altitude: 250.757129951577, last_updated:"2018-03-13 13:16:00")}
      reporter = SatelliteReporter.new
      expect(reporter.health).to eq({:message=>"Sustained Low Earth Orbit Resumed"})
    end



    it "returns 'Altitude is A-OK' when one average is below 160, but others are above and no records have minute below equal to true" do
      sat_info = {altitude: 166.757129951577, last_updated:"2018-03-13 13:16:00"}
      SatelliteRecord.create(altitude: 120.757129951577, last_updated:"2018-03-13 13:16:00")
        6.times {|i| SatelliteRecord.create(sat_info)}
        reporter = SatelliteReporter.new
      expect(reporter.health).to eq({:message=>"Altitude is A-OK"} )
    end
  end

end
