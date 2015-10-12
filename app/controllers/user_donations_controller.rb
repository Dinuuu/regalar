class UserDonationsController < ApplicationController
  include UserMailerHelper
  inherit_resources
  belongs_to :wish_item, optional: true
  defaults resource_class: Donation, collection_name: 'donations', instance_name: 'donation'

  before_action :authenticate_user!, except: [:confirmed]
  before_action :check_ownership, only: [:destroy]
  before_action :cancelable, only: [:destroy]
  before_action :check_finish_date, only: [:create]
  before_action :check_active, only: [:create]
  FIELDS = [:user_id, :wish_item_id, :quantity, :organization_id]

  def create
    wish_item
    create! do |success, failure|
      success.html do
        send_creation_mail(@wish_item)
        redirect_to :back
      end
      failure.html { render 'new' }
    end
  end

  def destroy
    @wish_item = donation.wish_item
    destroy! do |success, _failure|
      success.html do
        send_cancelation_mail(@wish_item, cancelation_params[:reason])
        redirect_to :back
      end
    end
  end

  private

  def check_finish_date
    return true unless wish_item.finished?
    render status: :forbidden,
           text: 'The request has already finished'
  end

  def check_active
    return true if wish_item.active?
    render status: :forbidden,
           text: 'The request is paused'
  end

  def wish_item
    @wish_item ||= WishItem.find(params[:id])
  end

  def check_ownership
    return true if donation.user_id == current_user.id
    render status: :forbidden, text: 'You must own the donation to cancel it'
  end

  def cancelable
    return true unless donation.done == true
    render status: :forbidden, text: 'The donation is already confirmed'
  end

  def donation
    @donation ||= Donation.find(params[:id])
  end

  def resource_params
    return [] if request.get?
    [params.require(:donation).permit(FIELDS)]
  end

  def cancelation_params
    params.require(:donation).permit(:reason)
  end
end
