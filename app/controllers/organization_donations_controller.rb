class OrganizationDonationsController < OrganizationAuthenticationController
  include OrganizationMailerHelper
  before_action :authenticate_user!, except: [:confirmed]
  before_action :chek_authentication_for_donation, except: [:confirmed, :pending]
  before_action :chek_authentication_for_organization, only: [:pending]

  def confirm
    @donation = Donation.find(params[:id])
    @wish_item = @donation.wish_item
    @wish_item.update_attributes!(obtained: @wish_item.obtained + @donation.quantity)
    @donation.update_attributes!(done: true)
    send_confirmation_email(@donation)
    redirect_to organization_wish_item_path(@wish_item.organization, @wish_item)
  end

  def cancel
    @donation = Donation.find(params[:id])
    @donation.destroy
    send_cancelation_email(@donation, cancelation_params[:reason])
    redirect_to organization_wish_item_path(@donation.organization, @donation.wish_item)
  end

  def show
    @donation = Donation.find(params[:id])
  end

  def confirmed
    organization = Organization.find(params[:organization_id])
    @confirmed = organization.confirmed_donations
  end

  def pending
    organization = Organization.find(params[:organization_id])
    @pending = organization.pending_donations
  end

  private

  def chek_authentication_for_donation
    @organization = Donation.find(params[:id]).organization
    return true if @organization.users.include? current_user
    render status: :forbidden,
           text: 'You must belong to the organization to access to this section'
  end

  def cancelation_params
    params.require(:donation).permit(:reason)
  end
end
