class Towns::Planner::HeightMapsController < ApplicationController
  def show
    town = current_user.towns.find(params[:town_id])
    height_map = town.height_maps.where(params.slice(:x, :y)).first
    render json: height_map.to_json
  end

  def update
    town = current_user.towns.find(params[:town_id])
    height_map = town.height_maps.where(params.slice(:x, :y)).first
    height_map.update_attribute(:area, params[:area])
    render json: height_map.to_json
  end

  def create
    town = current_user.towns.find(params[:town_id])
    permitted = params.require(:height_map).permit(:town_id, :x, :y)
    permitted[:area] = params[:height_map][:area]
    height_map = town.height_maps.create(permitted)
    render json: height_map.to_json
  end

  def index
    town = current_user.towns.find(params[:town_id])
    render json: town.height_maps.all.to_json
  end

  def changed
    town = Town.find(params[:town_id])

    time = 3.seconds
    changed = town.height_maps.where("updated_at > ?", DateTime.now.ago(time)).map { |d| [d.x, d.y] }
    created = town.height_maps.where("created_at > ?", DateTime.now.ago(time)).map { |d| [d.x, d.y] }
    result = {
      updated: (changed - created),
      created: created
    }
    
    render json: result.to_json
  end
end

