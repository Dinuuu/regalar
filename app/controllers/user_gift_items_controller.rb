class UserGiftItemsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :validate_user, except: [:show]

  def create
    @gift_item = GiftItem.new(gift_item_params.merge(user: current_user))
    if @gift_item.save
      redirect_to user_gift_item_path(current_user.id, @gift_item.id)
    else
      render 'new'
    end
  end

  def show
    gift_item
  end

  def edit
    gift_item
  end

  def update
    if gift_item.update_attributes(gift_item_params)
      redirect_to user_gift_item_path(current_user.id, @gift_item.id)
    else
      render 'edit'
    end
  end

  def new
    @gift_item = GiftItem.new
  end

  def index
    @gift_items = GiftItem.for_user(current_user)
  end

  private

  def validate_user
    return true if params[:user_id].to_i == current_user.id
    render status: :forbidden,
           text: 'You must be the specified user to access to this section'
  end

  def gift_item
    @gift_item ||= GiftItem.find(params[:id])
  end

  def gift_item_params
    params.require(:gift_item).permit(:title, :quantity, :unit,
                                      :description, :used_time,
                                      :measures, :weight, :status)
  end
end
