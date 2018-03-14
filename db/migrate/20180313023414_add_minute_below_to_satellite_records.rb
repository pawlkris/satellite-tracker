class AddMinuteBelowToSatelliteRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :satellite_records, :minute_below, :boolean, default:false
  end
end
