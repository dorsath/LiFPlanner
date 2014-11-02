class CreateTownsmen < ActiveRecord::Migration
  def change
    create_table :townsmen do |t|
      t.integer :town_id
      t.integer :user_id
      t.string  :name
      t.integer :rank
      t.integer :herbalism_list_id

      t.timestamps
    end
  end
end
