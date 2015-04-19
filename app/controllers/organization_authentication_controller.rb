class OrganizationAuthenticationController < ApplicationController
  protected

  def chek_authentication_for_organization
    @organization = Organization.find(params[:organization_id])
    return true if @organization.users.include? current_user
    render status: :forbidden,
           text: 'You must belong to the organization to access to this section'
  end
end
