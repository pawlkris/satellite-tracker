namespace :chron do
  desc 'Fetch api record data'
  task :fetch => :environment do
    6.times do |x|
      if SatelliteRecord.all.length == 31
        SatelliteRecord.first.delete
      end
      new_sat = SatelliteDataFetcher.fetch
      sleep 10
    end
  end
end
