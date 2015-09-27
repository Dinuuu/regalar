class OrganizationsController < ApplicationController
  inherit_resources

  before_action :authenticate_user!, except: [:index, :show]

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
    authorize Organization.find(params[:id])
    edit!
  end

  def update
    authorize Organization.find(params[:id])
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
    @comment = Comment.new(commentable: Organization.find(params[:id]))
    show!
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
