class UserGiftRequestsController < ApplicationController
  include UserMailerHelper
  before_action :authenticate_user!, except: [:confirmed]
  before_action :check_ownership, except: [:confirmed, :pending]
  before_action :validate_user, only: [:pending]

  def cancel
    @gift_request.destroy
    send_cancelation_email
    redirect_to :back
  end

  def show
    gift_request
  end

  def confirmed
    user = User.find_by_slug_or_id(params[:id])
    user.confirmed_gift_requests
  end

  def pending
    user = User.find_by_slug_or_id(params[:id])
    user.pending_gift_requests
  end

  private

  def gift_request
    @gift_request ||= GiftRequest.find_by_id(params[:id])
  end

  def gift_request_by_organization
    GiftRequest.find_by(organization: Organization.find_by_slug_or_id(params[:organization_id]),
                        gift_item: GiftItem.find_by_slug_or_id(params[:gift_item_id]),
                        user: current_user)
  end

  def check_ownership
    @gift_request = gift_request || gift_request_by_organization

    return render status: :forbidden,
                  text: "You don't own the item" unless gift_request.present? &&
                                                        gift_request.user_id == current_user.id
  end

  def validate_user
    return true if params[:id] == current_user.slug
    render status: :forbidden,
           text: 'You must be the specified user to access to this section'
  end
end
