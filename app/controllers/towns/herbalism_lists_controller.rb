class Towns::HerbalismListsController < ApplicationController
  def index
    @town = Town.find(params[:town_id])
    @townsmen_with_list = @town.townsmen.where.not(herbalism_list_id: nil)
    @my_townsman = @town.townsmen.where(user: current_user).first
  end
end

