class Towns::Planner::BuildingsController < ApplicationController
  def new
    @town = Town.find(params[:town_id])
    @building = @town.buildings.new
    @building.created_by = @town.townsmen.where(user_id: current_user.id).first
    render json: @building
  end

  def index
    @town = Town.find(params[:town_id])
    render json: @town.buildings.all.to_json(include: :created_by)
  end

  def create
    @town = Town.find(params[:town_id])
    my_townsman = @town.townsmen.where(user: current_user).first

    @building = @town.buildings.new(new_building_param)
    @building.created_by = my_townsman
    @building.area = params[:area]
    @building.save

    render json: @building
  end

  def show
    @town = Town.find(params[:town_id])
    @building = @town.buildings.find(params[:id])
    render json: @building.to_json(include: :created_by)
  end


  private

  def new_building_param
    params.permit(:title, :area, :note)
  end
end
