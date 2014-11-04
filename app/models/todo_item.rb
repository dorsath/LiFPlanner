class TodoItem < ActiveRecord::Base
  belongs_to :todo_list
  belongs_to :created_by, foreign_key: "created_by_id", class_name: "Townsman"
end
