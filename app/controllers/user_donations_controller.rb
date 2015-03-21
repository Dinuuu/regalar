class UserDonationsController < ApplicationController
  inherit_resources
  belongs_to :wish_item, optional: true
  defaults resource_class: Donation, collection_name: 'donations', instance_name: 'donation'

  before_action :authenticate_user!
  before_action :check_ownership, only: [:destroy]
  before_action :cancelable, only: [:destroy]
  FIELDS = [:user_id, :wish_item_id, :quantity, :organization_id]

  def create
    @wish_item = WishItem.find(params[:wish_item_id])
    create! do |success, failure|
      success.html { redirect_to organization_wish_item_path(@wish_item.organization, @wish_item) }
      failure.html { render 'new' }
    end
  end

  def destroy
    @wish_item = donation.wish_item
    destroy! do |success, _failure|
      success.html { redirect_to organization_wish_item_path(@wish_item.organization, @wish_item) }
    end
  end

  private

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
end
