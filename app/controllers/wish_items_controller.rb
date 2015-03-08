class WishItemsController < ApplicationController
  inherit_resources
  belongs_to :organization
  before_action :authenticate_user!

  def index
    @wish_items = WishItem.for_organization(@organization)
    index!
  end

  def destroy
    destroy! { @organization }
  end

  def create
    create! { @organization }
  end

  private

  def resource_params
    return [] if request.get?
    [params.require(:wish_item).permit(:title, :reason, :description, :priority,
                                       :quantity, :unit, :organization_id)]
  end
end
