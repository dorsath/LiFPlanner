class CreateTodoItems < ActiveRecord::Migration
  def change
    create_table :todo_items do |t|
      t.integer :todo_list_id
      t.string :title
      t.text :note

      t.integer :assigned_to_id
      t.integer :created_by_id
      t.integer :order
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
