class PendingInvitesController < ApplicationController
  def create
    user = User.find_by_username(params[:pending_invite][:username])
    town = Town.find(params[:town_id])

    result = PendingInvite.create(user: user, town: town, invited_by: current_user)
    flash[:success] = "#{user.username} has been invited."
    
    redirect_to town_path(town)
  end

  def accept
    invite = PendingInvite.find(params[:id])
    town = invite.town
    if invite.user == current_user
      town.add_townsman(invite.user, :member, params[:townsman][:name])
      invite.delete
      redirect_to town_path(town)
    else
      redirect_to root_path
    end

  end
end
