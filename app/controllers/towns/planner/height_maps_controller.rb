class Towns::Planner::HeightMapsController < ApplicationController
  def show
    town = current_user.towns.find(params[:town_id])
    height_map = town.height_maps.where(params.slice(:x, :y)).first
    render json: height_map.to_json
  end
end

