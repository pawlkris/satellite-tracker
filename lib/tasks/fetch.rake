namespace :chron do
  desc 'Fetch api record data'
  task :fetch => :environment do
    1.upto(6) do |x|
      if SatelliteRecord.all.length == 31
        SatelliteRecord.first.delete
      end
      new_sat = SatelliteRecord.fetch
      sleep 10
    end
  end
end
