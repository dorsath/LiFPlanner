class Towns::TodoListsController < ApplicationController
  def show
    @town = Town.find(params[:town_id])
    @todo_list = @town.todo_list
    @active = "todolist"
  end
end
