require 'rails_helper'

RSpec.describe SatelliteRecord, type: :model do

  describe "SatelliteRecord.minute_below?" do
    it "returns true when last six records have average altitude below 160" do
      6.times {|i| SatelliteRecord.create(altitude: 120, last_updated:"2018-03-13 13:16:00")}
      expect(SatelliteRecord.minute_below?(SatelliteRecord.last)).to eq(true)
    end
    it "returns false when at least one of six records have average altitude below 160" do
      SatelliteRecord.create(altitude: 180, last_updated:"2018-03-13 13:16:00")
      5.times {|i| SatelliteRecord.create(altitude: 120, last_updated:"2018-03-13 13:16:00")}
      expect(SatelliteRecord.minute_below?(SatelliteRecord.last)).to eq(false)
    end
  end

  describe "SatelliteRecord.average" do
    it "returns average of previous 30 records plus input of the current record (0:00 to 5:00)" do
      30.times {|i| SatelliteRecord.create(altitude: 1, last_updated:"2018-03-13 13:16:00")}
      expect(SatelliteRecord.average(32)).to eq(2)
    end
    it "returns the correct average if there are fewer than 30 records" do
      10.times {|i| SatelliteRecord.create(altitude: 1, last_updated:"2018-03-13 13:16:00")}
      expect(SatelliteRecord.average(12)).to eq(2)
    end
  end


end
