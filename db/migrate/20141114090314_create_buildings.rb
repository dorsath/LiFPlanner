class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.integer :town_id
      t.integer :created_by_id
      t.text :note
      t.string :title
      t.text :area

      t.timestamps
    end
  end
end
