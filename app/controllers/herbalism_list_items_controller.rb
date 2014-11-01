class HerbalismListItemsController < ApplicationController
  layout false

  def show
    @list = HerbalismList.find(params[:herbalism_list_id])
    @herb_item = @list.herbalism_list_items.find(params[:id])
    
    respond_to do |format|
      format.json do
        render json: @herb_item.to_json
      end
    end
  end

  def edit
    @list = HerbalismList.find(params[:herbalism_list_id])
    @herb_item = @list.herbalism_list_items.find(params[:id])
    @effect_id = params[:herb_id].to_i
  end

  def update
    @list = HerbalismList.find(params[:herbalism_list_id])
    @herb_item = @list.herbalism_list_items.find(params[:id])
    update = params.require(:herbalism_list_item).permit(:first_effect_id, :second_effect_id, :third_effect_id)
    render json: @herb_item.update_attributes(update)
  end
end

