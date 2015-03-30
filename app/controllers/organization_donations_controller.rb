class OrganizationDonationsController < ApplicationController
  before_action :authenticate_user!, except: [:confirmed]
  before_action :chek_authentication, except: [:confirmed]

  def confirm
    @donation = Donation.find(params[:id])
    @wish_item = @donation.wish_item
    update_wish_item_quantity(@wish_item, @donation.quantity)
    @donation.update_attributes!(done: true)
    send_confirmation_email(@donation)
    redirect_to organization_wish_item_path(@wish_item.organization, @wish_item)
  end

  def cancel
    @donation = Donation.find(params[:id])
    @donation.destroy
    send_cancelation_email(@donation)
    redirect_to organization_wish_item_path(@donation.organization, @donation.wish_item)
  end

  def show
    @donation = Donation.find(params[:id])
    render 'show'
  end

  def confirmed
    organization = Organization.find(params[:organization_id])
    @confirmed = Donation.for_organization(organization).done
    render 'confirmed'
  end

  private

  def send_confirmation_email(donation)
    OrganizationMailer
      .confirm_donation_email(donation.user, donation.organization, donation.wish_item).deliver
  end

  def send_cancelation_email(donation)
    OrganizationMailer
      .cancel_donation_email(donation.user, donation.organization, donation.wish_item).deliver
  end

  def update_wish_item_quantity(wish_item, quantity)
    if wish_item.quantity > quantity
      quantity = wish_item.quantity - quantity
    else
      quantity = 0
    end
    @wish_item.update_attributes!(quantity: quantity)
  end

  def chek_authentication
    @organization = Donation.find(params[:id]).organization
    return true if @organization.users.include? current_user
    render status: :forbidden,
           text: 'You must belong to the organization to access to this section'
  end
end
