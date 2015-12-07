class UserGiftRequestsController < ApplicationController
  include UserMailerHelper
  before_action :authenticate_user!, except: [:confirmed]
  before_action :check_ownership, except: [:confirmed, :pending]
  before_action :validate_user, only: [:pending]

  def cancel
    @gift_request = GiftRequest.find_by(organization_id: params[:organization_id],
                                        gift_item_id: params[:gift_item_id])
    gift_request.destroy
    send_cancelation_email
    redirect_to user_gift_item_path(current_user, gift_request.gift_item)
  end

  def show
    gift_request
  end

  def confirmed
    user = User.find(params[:id])
    user.confirmed_gift_requests
  end

  def pending
    user = User.find(params[:id])
    user.pending_gift_requests
  end

  private

  def gift_request
    @gift_request ||= GiftRequest.find(params[:id])
  end

  def check_ownership
    request_to_cancel = GiftRequest.find_by(organization_id: params[:organization_id],
                                            gift_item_id: params[:gift_item_id])
    @gift_request = request_to_cancel || gift_request
    return render status: :forbidden,
                  text: "You don't own the item" unless gift_request.user_id == current_user.id
  end

  def validate_user
    return true if params[:id].to_i == current_user.id
    render status: :forbidden,
           text: 'You must be the specified user to access to this section'
  end
end
