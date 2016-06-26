class UserGiftItemsController < ApplicationController
  include UserMailerHelper
  before_action :authenticate_user!, except: [:show, :new]
  before_action :validate_user, except: [:show]

  def show
    @comment = Comment.new(commentable: GiftItem.find_by_slug_or_id(params[:id]))
    gift_item.visit
    add_visit_to_cookie
    gift_item
  end

  def edit
    authorize gift_item
    gift_item
  end

  def destroy
    authorize gift_item
    gift_item.update_attributes(eliminated: true)
    send_mails_to_undone_gift_requests
    redirect_to :back
  end

  def update
    authorize gift_item
    if gift_item.update_attributes(gift_item_params)
      redirect_to user_gift_item_path(current_user.slug, @gift_item.slug)
    else
      render 'edit'
    end
  end

  def new
    @gift_item = GiftItem.new
  end

  def index
    @gift_items = GiftItem.for_user(current_user).not_eliminated
  end

  private

  def validate_user
    return true if params[:user_id] == current_user.slug
    render status: :forbidden,
           text: 'You must be the specified user to access to this section'
  end

  def gift_item
    @gift_item ||= GiftItem.find_by_slug_or_id(params[:id])
  end

  def gift_item_params
    params.require(:gift_item).permit(:title, :quantity, :unit,
                                      :description, :used_time,
                                      :measures, :weight, :status,
                                      gift_item_images_attributes: [:gift_item_id, :file,
                                                                    :remote_file_url,
                                                                    :id, :_destroy])
  end

  def add_visit_to_cookie
    cookies.permanent[:visited_gift_items] = JSON.generate(new_visits)
  end

  def new_visits
    return [params[:id]] unless cookies[:visited_gift_items].present?
    JSON.parse(cookies[:visited_gift_items]) << params[:id]
  end

  def send_mails_to_undone_gift_requests
    gift_item.gift_requests.pending.each do |req|
      @gift_request = req
      req.destroy
      send_cancelation_email
    end
  end
end
