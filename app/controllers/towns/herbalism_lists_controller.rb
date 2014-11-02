class Towns::HerbalismListsController < ApplicationController
  def index
    @town = Town.find(params[:town_id])
    @townsmen_with_list = @town.townsmen.where.not(herbalism_list_id: nil)
    @active = "herbalism"
    @my_townsman = @town.townsmen.where(user: current_user).first
  end

  def show
    @herbalism_list = HerbalismList.find(params[:id])
    @editable = false

    render "herbalism_lists/show"
  end

  def update
    townsman = Townsman.find(params[:id])
    townsman.update_attribute(:herbalism_list_id, params[:townsman][:herbalism_list_id])
    redirect_to town_herbalism_lists_path(townsman)
  end
end

