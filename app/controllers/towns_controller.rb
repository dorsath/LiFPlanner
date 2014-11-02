class TownsController < ApplicationController
  def index
    @towns = current_user.towns
    @pending_invites = PendingInvite.where(user: current_user)
  end

  def create
    town = Town.create(params.require(:town).permit(:name)).tap do |town|
      town.add_townsman(current_user, :founder, params[:town][:character_name])
    end

    redirect_to town_path(town)
  end

  def new
  end

  def show
    @town = current_user.towns.find(params[:id])
  end
end

