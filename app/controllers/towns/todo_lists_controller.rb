class Towns::TodoListsController < ApplicationController
  def show
    @javascript = "todolist"
    @town = Town.find(params[:town_id])
    @todo_list = @town.todo_list
    @active = "todolist"
  end
end
