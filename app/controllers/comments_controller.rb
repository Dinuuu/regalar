class CommentsController < ApplicationController
  inherit_resources

  before_action :authenticate_user!
  polymorphic_belongs_to :organization, :wish_item

  FIELDS = [:message]

  def create
    build_resource.user = current_user
    create! do
      redirect_to :back && return
    end
  end

  def resource_params
    return [] if request.get?
    [params.require(:comment).permit(FIELDS)]
  end
end
