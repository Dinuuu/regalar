class UserGiftRequestsController < ApplicationController
  before_action :authenticate_user!, except: [:confirmed]
  before_action :check_ownership, except: [:confirmed, :pending]
  before_action :check_confirmable, only: [:confirm]
  before_action :validate_user, only: [:pending]

  def confirm
    gift_request.gift_item.update_attributes(given: given_quantity(gift_request))
    gift_request.update_attributes(done: true)
    redirect_to user_gift_item_path(current_user, gift_request.gift_item)
  end

  def cancel
    gift_request.destroy
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

  def given_quantity(gift_request)
    gift_item = gift_request.gift_item
    left = gift_item.quantity - gift_item.given
    if left >= gift_request.quantity
      return gift_request.quantity + gift_item.given
    else
      return gift_item.quantity
    end
  end

  def gift_request
    @gift_request ||= GiftRequest.find(params[:id])
  end

  def check_ownership
    return render status: :forbidden,
                  text: "You don't own the item" unless gift_request.user_id == current_user.id
  end

  def check_confirmable
    return render status: :forbidden,
                  text: "You don't have items to
                    give or is already confirmed" if (gift_request.gift_item.given >=
                                                     gift_request.gift_item.quantity) ||
                                                     gift_request.done
  end

  def validate_user
    return true if params[:id].to_i == current_user.id
    render status: :forbidden,
           text: 'You must be the specified user to access to this section'
  end
end
