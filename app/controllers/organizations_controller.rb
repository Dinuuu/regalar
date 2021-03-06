class OrganizationsController < ApplicationController
  inherit_resources

  defaults resource_class: Organization, collection_name: 'organizations',
           instance_name: 'organization', finder: :find_by_slug_or_id

  before_action :authenticate_user!, except: [:index, :show, :new]

  FIELDS = [:name, :description, :locality, :email, :logo, :website]

  def list
    @organizations = current_user.organizations.page(params[:page] || 1)
  end

  def create
    create! do
      if @organization.valid?
        @organization.users << current_user
        @organization.users << User.where(id: users_ids)
        organization_path @organization
      end
    end
  end

  def edit
    authorize Organization.find_by_slug_or_id(params[:id])
    edit!
  end

  def update
    authorize Organization.find_by_slug_or_id(params[:id])
    update! do
      if @organization.valid?
        @organization.users << User.where(id: users_ids)
        organization_path @organization
      end
    end
  end

  def index
    if params[:query].present?
      @organizations = Organization.search(params[:query])
    else
      @organizations = Organization.all
    end
    index! { @organizations = @organizations.page(params[:page] || 1) }
  end

  def show
    @comment = Comment.new(commentable: Organization.find_by_slug_or_id(params[:id]))
    show!
  end

  def administrate
    @organization = Organization.find_by_slug_or_id(params[:id])
    @pending_wishes = @organization.wish_items.goal_not_reached.not_eliminated
    @pending_donations = @organization.donations.pending
    @pending_gifts = @organization.gift_requests.pending
  end

  private

  def users_ids
    return [] unless params[:organization][:users].present?
    user_ids = []
    params[:organization][:users].each do |id|
      user_ids << id unless @organization.users.ids.include? id.to_i
    end
    user_ids
  end

  def resource_params
    return [] if request.get?
    [params.require(:organization).permit(FIELDS)]
  end
end
