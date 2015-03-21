class UserDonationsController < ApplicationController
  inherit_resources
  belongs_to :wish_item, optional: true
  defaults resource_class: Donation, collection_name: 'donations', instance_name: 'donation'

  before_action :authenticate_user!, except: [:confirmed]
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

  def confirmed
    user = User.find(params[:id])
    organizations_id = Donation.for_user(user).done.uniq.pluck(:organization_id)
    @donations = []
    organizations_id.each_with_index do |org_id, index|
      @donations[index] = concreted_donations_for_organization(org_id, user)
    end
  end

  def destroy
    @wish_item = donation.wish_item
    destroy! do |success, _failure|
      success.html { redirect_to organization_wish_item_path(@wish_item.organization, @wish_item) }
    end
  end

  private

  def concreted_donations_for_organization(org_id, user)
    organization = Organization.find(org_id)
    organization_donations = {}
    organization_donations[:organization] = organization
    organization_donations[:donations] = Donation.for_user(user)
                                         .for_organization(organization).done
    organization_donations
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
end
