class HerbalismListsController < ApplicationController
  def index
    @herbalism_lists = HerbalismList.all
  end

  def show
    @herbalism_list = HerbalismList.find(params[:id])
  end

  def create
    list = HerbalismList.create(new_list_params).tap do |list|
      Herb.all.each do |herb|
        list.herbalism_list_items.create(herb_id: herb.id)
      end
    end

    redirect_to herbalism_list_path(list)
  end

  private

  def new_list_params
    params.require('herbalism_list').permit('server').merge(user: current_user)
  end
end
