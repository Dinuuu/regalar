class OrganizationGiftRequestsController < ApplicationController
  inherit_resources
  belongs_to :gift_item, optional: true
  defaults resource_class: GiftRequest, collection_name: 'gift_requests',
           instance_name: 'gift_request'
  before_action :authenticate_user!
  before_action :check_organization, only: [:create]
  before_action :check_ownership, only: [:destroy]
  before_action :cancelable, only: [:destroy]
  FIELDS = [:user_id, :gift_item_id, :quantity, :organization_id]

  def create
    gift_item
    create! do |success, failure|
      success.html do
        redirect_to :back
      end
      failure.html { render 'new' }
    end
  end

  def destroy
    destroy! do |success, _failure|
      success.html do
        redirect_to :back
      end
    end
  end

  private

  def check_ownership
    @organization = GiftRequest.find(params[:id]).organization
    return true if @organization.users.include? current_user
    render status: :forbidden,
           text: 'You must belong to the organization to do that'
  end

  def check_organization
    organization = Organization.find(resource_params[0][:organization_id])
    return true if current_user.organizations.include? organization
    render status: :forbidden,
           text: 'You must belong to the organization to do that'
  end

  def cancelable
    return true unless gift_request.done == true
    render status: :forbidden, text: 'The request is already confirmed'
  end

  def gift_item
    @gift_item ||= GiftItem.find(params[:id])
  end

  def gift_request
    @gift_request ||= GiftRequest.find(params[:id])
  end

  def resource_params
    return [] if request.get?
    [params.require(:gift_request).permit(FIELDS)]
  end
end