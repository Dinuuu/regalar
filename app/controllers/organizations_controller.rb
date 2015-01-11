class OrganizationsController < ApplicationController

  inherit_resources

  before_action :authenticate_user!, except: [:index, :show]

  FIELDS = [:name, :description, :locality]

  def list
    @organizations = current_user.organizations.page(params[:page] || 1)
  end

  def create
    create! do
      if @organization.valid?
        @organization.users << current_user
        organization_path @organization
      end
    end
  end

  def index
    index! { @organizations = @organizations.page(params[:page] || 1) }
  end

  private

  def resource_params
    return [] if request.get?
    [params.require(:organization).permit(FIELDS)]
  end

end
