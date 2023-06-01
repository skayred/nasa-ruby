class CreateProximityEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :proximity_events do |t|
      t.integer :asteroid_id
      t.float :miss_distance
      t.timestamp :happened_at

      t.timestamps
    end
  end
end
