class GiftItemsController < ApplicationController
  inherit_resources

  defaults resource_class: GiftItem, collection_name: 'gift_items', instance_name: 'gift_item',
           finder: :find_by_slug_or_id

  before_action :authenticate_user!, except: [:index, :new, :show]

  def new
    @gift_item = GiftItem.new
  end

  def create
    @gift_item = GiftItem.new(gift_item_params.merge(user: current_user))
    if @gift_item.save
      redirect_to user_gift_item_path(current_user.slug, @gift_item.slug)
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
                                                                    :remote_file_url, :id,
                                                                    :_destroy])
  end
end
