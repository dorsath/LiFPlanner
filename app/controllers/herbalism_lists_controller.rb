class HerbalismListsController < ApplicationController
  def index
    @herbalism_lists = HerbalismList.where(user: current_user).all
  end

  def show
    @herbalism_list = HerbalismList.find(params[:id])
    @editable = true

    respond_to do |format|
      format.json do
        json_list = @herbalism_list.as_json
        json_list["items"] = @herbalism_list.herbalism_list_items.as_json.map {|t|
          t["herb"] = Herb.select(:id, :name, :img_path).find(t["herb_id"])
          t
        }
        render json: json_list
      end
      format.html
    end
  end

  def create
    list = HerbalismList.create(new_list_params).tap do |list|
      Herb.all.each do |herb|
        list.herbalism_list_items.create(herb_id: herb.id)
      end
    end

    redirect_to herbalism_list_path(list)
  end

  def effects
    respond_to do |format|
      format.json do
        render json: Herb.effects.to_json
      end
    end
  end

  private

  def new_list_params
    params.require('herbalism_list').permit('server').merge(user: current_user)
  end
end
