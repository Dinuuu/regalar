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
        byebug
        @organization.users << current_user
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

  def resource_params
    return [] if request.get?
    [params.require(:organization).permit(FIELDS)]
  end
end
