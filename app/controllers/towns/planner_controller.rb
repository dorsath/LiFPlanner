class Towns::PlannerController < ApplicationController
  def show
    @javascript = "planner"
    @active = "town_planner"
    @town = Town.find(params[:town_id])
  end

  def changed
    town = Town.find(params[:town_id])

    time = 3.seconds
    changed_buildings = town.buildings.where("updated_at > ?", DateTime.now.ago(time)).map(&:id)
    created_buildings = town.buildings.where("created_at > ?", DateTime.now.ago(time)).map(&:id)

    changed_height_maps = town.height_maps.where("updated_at > ?", DateTime.now.ago(time)).map { |d| [d.x, d.y] }
    created_height_maps = town.height_maps.where("created_at > ?", DateTime.now.ago(time)).map { |d| [d.x, d.y] }
    result = {
      building: {
        updated: (changed_buildings - created_buildings),
        created: created_buildings
      },
      height_map: {
        updated: (changed_height_maps - created_height_maps),
        created: created_height_maps
      }
    }
    
    render json: result.to_json
  end
end
