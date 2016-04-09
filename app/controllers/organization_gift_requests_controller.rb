class OrganizationGiftRequestsController < ApplicationController
  inherit_resources
  include OrganizationMailerHelper
  nested_belongs_to :user, :gift_item, optional: true
  defaults resource_class: GiftRequest, collection_name: 'gift_requests',
           instance_name: 'gift_request'
  before_action :authenticate_user!
  before_action :check_organization, only: [:create]
  before_action :check_ownership, only: [:destroy, :confirm]
  before_action :cancelable, only: [:destroy]
  before_action :check_confirmable, only: [:confirm]
  FIELDS = [:user_id, :gift_item_id, :quantity, :organization_id]

  def create
    authorize gift_item
    create! do |success, failure|
      success.html do
        send_creation_mail
        redirect_to :back
      end
      failure.html do
        render 'new'
      end
    end
  end

  def confirm
    gift_request.gift_item.update_attributes(given: given_quantity(gift_request))
    gift_request.update_attributes(done: true)
    send_confirmation_mail
    redirect_to :back
  end

  def destroy
    destroy! do |success, _failure|
      success.html do
        send_cancelation_mail
        redirect_to :back
      end
    end
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

  def check_ownership
    @organization = GiftRequest.find(params[:id]).organization
    belongs_to_org?(organization)
  end

  def check_organization
    belongs_to_org?(organization)
  end

  def belongs_to_org?(org)
    return true if current_user.organizations.include? org
    render status: :forbidden,
           text: 'You must belong to the organization to do that'
  end

  def cancelable
    return true unless gift_request.done == true
    render status: :forbidden, text: 'The request is already confirmed'
  end

  def gift_item
    @gift_item ||= GiftItem.find(params[:gift_item_id])
  end

  def gift_request
    @gift_request ||= GiftRequest.find(params[:id])
  end

  def organization
    @organization ||= Organization.find(resource_params[0][:organization_id])
  end

  def resource_params
    return [] if request.get?
    [params.require(:gift_request).permit(FIELDS)]
  end

  def check_confirmable
    return render status: :forbidden,
                  text: "You don't have items to give or is already confirmed" if
                  (gift_request.gift_item.given >= gift_request.gift_item.quantity) ||
                  gift_request.done
  end
end
