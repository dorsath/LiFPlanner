class TownsController < ApplicationController
  def index
    @towns = current_user.towns
  end

  def create
    town = Town.create(params.require(:town).permit(:name)).tap do |town|
      town.add_townsman(current_user, :founder, params[:town][:character_name])
    end

    redirect_to town_path(town)
  end

  def show
    @town = current_user.towns.find(params[:id])
  end
end

