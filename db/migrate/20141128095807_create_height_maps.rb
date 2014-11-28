class CreateHeightMaps < ActiveRecord::Migration
  def change
    create_table :height_maps do |t|
      t.integer :town_id
      t.text :area
      t.integer :x
      t.integer :y

      t.timestamps
    end
  end
end
