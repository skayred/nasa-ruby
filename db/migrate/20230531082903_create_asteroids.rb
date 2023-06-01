class CreateAsteroids < ActiveRecord::Migration[7.0]
  def change
    create_table :asteroids do |t|
      t.string :nasa_id
      t.string :name

      t.timestamps
    end
  end
end
