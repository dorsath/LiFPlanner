class CreateHerbalismListItems < ActiveRecord::Migration
  def change
    create_table :herbalism_list_items do |t|
      t.integer :herbalism_list_id
      t.integer :herb_id
      t.integer :first_effect_id, default: 0
      t.integer :second_effect_id, default: 0
      t.integer :third_effect_id, default: 0

      t.timestamps
    end
  end
end
