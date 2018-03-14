class CreateSatelliteRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :satellite_records do |t|
      t.float :altitude
      t.float :average
      t.datetime :last_updated

      t.timestamps
    end
  end
end
