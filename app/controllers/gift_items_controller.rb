class GiftItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :new, :show]

  def new
    @gift_item = GiftItem.new
  end

  def create
    @gift_item = GiftItem.new(gift_item_params.merge(user: current_user))
    if @gift_item.save
      redirect_to user_gift_item_path(current_user.id, @gift_item.id)
    else
      render 'new'
    end
  end

  def index
    @gift_items = GiftItem.still_available.not_eliminated
    @gift_items = params[:query].present? ? @gift_items.search(params[:query]) : @gift_items
  end

  private

  def gift_item_params
    params.require(:gift_item).permit(:title, :quantity, :unit,
                                      :description, :used_time,
                                      :measures, :weight, :status,
                                      gift_item_images_attributes: [:gift_item_id, :file,
                                                                    :remote_file_url])
  end
end
