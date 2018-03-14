require 'rails_helper'

RSpec.describe SatelliteRecord, type: :model do

  describe "SatelliteRecord.minute_below?" do
    it "returns true when last six records have altitude below 160" do
      6.times {|i| SatelliteRecord.create(altitude: 120, average:120, last_updated:"2018-03-13 13:16:00", minute_below:false)}
      expect(SatelliteRecord.minute_below?).to eq(true)
    end
    it "returns false when at least one of six records have altitude below 160" do
      SatelliteRecord.create(altitude: 180, average:180, last_updated:"2018-03-13 13:16:00", minute_below:false)
      5.times {|i| SatelliteRecord.create(altitude: 120, average:120, last_updated:"2018-03-13 13:16:00", minute_below:false)}
      expect(SatelliteRecord.minute_below?).to eq(false)
    end
  end

  describe "SatelliteRecord.average" do
    it "returns average of previous 30 records plus input of the current record" do
      30.times {|i| SatelliteRecord.create(altitude: 1, average:120, last_updated:"2018-03-13 13:16:00", minute_below:false)}
      expect(SatelliteRecord.average(32)).to eq(2)
    end
    it "returns the correct average if there are fewer than 30 records" do
      10.times {|i| SatelliteRecord.create(altitude: 1, average:120, last_updated:"2018-03-13 13:16:00", minute_below:false)}
      expect(SatelliteRecord.average(12)).to eq(2)
    end
  end

  describe "SatelliteRecord.message" do
    it "returns 'WARNING: RAPID ORBITAL DECAY IMMINENT' when previous 7 records' averages are below 160, thus making the last record's minute_below status true" do
      6.times {|i| SatelliteRecord.create(altitude: 120, average:120, last_updated:"2018-03-13 13:16:00", minute_below:false)}
      SatelliteRecord.create(altitude: 120.757129951577, average:120.733756966261, last_updated:"2018-03-13 13:16:00", minute_below:SatelliteRecord.minute_below?)
      expect(SatelliteRecord.message).to eq({:message=>"WARNING: RAPID ORBITAL DECAY IMMINENT"} )
    end
    it "returns 'WARNING: RAPID ORBITAL DECAY IMMINENT' when previous 6 records' averages are below 160" do
      6.times {|i| SatelliteRecord.create(altitude: 120, average:120, last_updated:"2018-03-13 13:16:00", minute_below:false)}
      SatelliteRecord.create(altitude: 120.757129951577, average:120.733756966261, last_updated:"2018-03-13 13:16:00", minute_below:SatelliteRecord.minute_below?)
      expect(SatelliteRecord.message).to eq({:message=>"WARNING: RAPID ORBITAL DECAY IMMINENT"} )
    end


    it "returns 'Sustained Low Earth Orbit Resumed' when at least one of the past seven records' altitudes is above 160 at least one record's minute_below? status is true" do
      6.times{|i| SatelliteRecord.create(altitude: 120.757129951577, average:120.733756966261, last_updated:"2018-03-13 13:16:00", minute_below:true)}
      SatelliteRecord.create(altitude: 166.757129951577, average:182.733756966261, last_updated:"2018-03-13 13:16:00", minute_below:false)
      expect(SatelliteRecord.message).to eq({:message=>"Sustained Low Earth Orbit Resumed"} )
    end


    it "returns 'Altitude is A-OK' when one average is above 160 and minute_below is false" do
      6.times {|i| SatelliteRecord.create(altitude: 166.757129951577, average:182.733756966261, last_updated:"2018-03-13 13:16:00", minute_below:false)}
      expect(SatelliteRecord.message).to eq({:message=>"Altitude is A-OK"} )
    end
    it "returns 'Altitude is A-OK' when one average is below 160, but others are above and no records have minute below equal to true" do
      sat_info = {altitude: 166.757129951577, average:182.733756966261, last_updated:"2018-03-13 13:16:00", minute_below:false}
      SatelliteRecord.create(altitude: 120.757129951577, average:120.733756966261, last_updated:"2018-03-13 13:16:00", minute_below:false)
        6.times {|i| SatelliteRecord.create(sat_info)}
      expect(SatelliteRecord.message).to eq({:message=>"Altitude is A-OK"} )
    end
  end

end
