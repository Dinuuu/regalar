class UserGiftItemsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :validate_user, except: [:show]

  def show
    @comment = Comment.new(commentable: GiftItem.find(params[:id]))
    gift_item.visit
    add_visit_to_cookie
    gift_item
  end

  def edit
    gift_item
  end

  def destroy
    # TODO: IMPLEMENTAR
    redirect_to :back
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
                                      :measures, :weight, :status,
                                      gift_item_images_attributes: [:gift_item_id, :file,
                                                                    :remote_file_url])
  end

  def add_visit_to_cookie
    cookies.permanent[:visited_gift_items] = JSON.generate(new_visits)
  end

  def new_visits
    return [params[:id]] unless cookies[:visited_gift_items].present?
    JSON.parse(cookies[:visited_gift_items]) << params[:id]
  end
end
