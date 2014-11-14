class Towns::PlannerController < ApplicationController
  def show
    @javascript = "planner"
    @active = "town_planner"
    @town = Town.find(params[:town_id])
  end

  def changed
    @town = Town.find(params[:town_id])

    time = 3.seconds
    changed = @town.buildings.where("updated_at > ?", DateTime.now.ago(time)).map(&:id)
    created = @town.buildings.where("created_at > ?", DateTime.now.ago(time)).map(&:id)
    result = {
      updated: (changed - created),
      created: created
    }
    
    render json: result.to_json
  end
end
