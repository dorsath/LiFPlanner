class Towns::TodoItemsController < ApplicationController
  def index
    @javascript = "todolist"
    @town = Town.find(params[:town_id])
    @todo_list = @town.todo_list
    render json: @todo_list.items.as_json(include: :created_by)
  end
  
  def create
    @town = Town.find(params[:town_id])
    my_townsman = @town.townsmen.where(user: current_user).first
    @item = @town.todo_list.items.create(new_todo_item_params.merge(created_by: my_townsman))
    render json: @item.to_json(include: :created_by)
  end

  def show
    @town = Town.find(params[:town_id])
    @item = @town.todo_list.items.find(params[:id])
    render json: @item.to_json(include: :created_by)
  end

  def update
    @town = Town.find(params[:town_id])
    @item = @town.todo_list.items.find(params[:id])
    @item.update_attributes(new_todo_item_params)
    render json: @item.to_json(include: :created_by)
  end

  private

  def new_todo_item_params
    params.require(:todo_item).permit(:title, :completed)
  end
end

