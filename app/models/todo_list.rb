class TodoList < ActiveRecord::Base
  belongs_to :town
  has_many :items, class_name: "TodoItem"
end
