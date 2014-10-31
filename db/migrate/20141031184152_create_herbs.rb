class CreateHerbs < ActiveRecord::Migration
  def change
    create_table :herbs do |t|
      t.string :name
      t.string :img_path

      t.timestamps
    end
  end
end
