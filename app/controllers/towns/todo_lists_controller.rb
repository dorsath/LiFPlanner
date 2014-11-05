class Towns::TodoListsController < ApplicationController
  def show
    @javascript = "todolist"
    @town = Town.find(params[:town_id])
    @todo_list = @town.todo_list
    @active = "todolist"
  end

  def changed
    @town = Town.find(params[:town_id])
    @todo_list = @town.todo_list

    time = 3.seconds
    changed = @todo_list.items.where("updated_at > ?", DateTime.now.ago(time)).map(&:id)
    created = @todo_list.items.where("created_at > ?", DateTime.now.ago(time)).map(&:id)
    result = { 
      updated: (changed - created),
      created: created
    }
    
    render json: result.to_json
  end
end
