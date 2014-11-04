class CreateTodoLists < ActiveRecord::Migration
  def change
    create_table :todo_lists do |t|
      t.integer :town_id

      t.timestamps
    end

    Town.all.each do |town|
      TodoList.create(town_id: town.id)
    end
  end
end
