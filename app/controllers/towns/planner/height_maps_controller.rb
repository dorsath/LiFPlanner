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
    height_map = town.height_maps.create(params.permit(:town_id, :x, :y, :area))
    render json: height_map.to_json
  end

  def index
    town = current_user.towns.find(params[:town_id])
    render json: town.height_maps.all.to_json
  end
end

