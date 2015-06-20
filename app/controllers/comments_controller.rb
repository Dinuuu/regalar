class CommentsController < ApplicationController
  inherit_resources

  before_action :authenticate_user!
  polymorphic_belongs_to :organization, :wish_item, :gift_item

  FIELDS = [:message]

  def create
    build_resource.user = current_user
    create! do
      return redirect_to :back
    end
  end

  def resource_params
    return [] if request.get?
    [params.require(:comment).permit(FIELDS)]
  end
end
