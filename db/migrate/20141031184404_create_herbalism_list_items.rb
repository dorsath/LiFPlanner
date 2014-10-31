class CreateHerbalismListItems < ActiveRecord::Migration
  def change
    create_table :herbalism_list_items do |t|
      t.integer :list_id
      t.integer :first_effect_id
      t.integer :second_effect_id
      t.integer :third_effect_id

      t.timestamps
    end
  end
end
