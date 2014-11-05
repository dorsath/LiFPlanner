class Towns::PlannerController < ApplicationController
  def show
    @javascript = "planner"
    @active = "town_planner"
    @town = Town.find(params[:town_id])
  end
end
