class CommentsController < ApplicationController
  inherit_resources

  before_action :authenticate_user!
  polymorphic_belongs_to :organization, :campaign

  FIELDS = [:message]

  def create
    build_resource.user = current_user
    create! do
      parent.is_a?(Campaign) ? organization_campaign_url(parent.organization, parent) : parent_url
    end
  end

  def resource_params
    return [] if request.get?
    [params.require(:comment).permit(FIELDS)]
  end
end
