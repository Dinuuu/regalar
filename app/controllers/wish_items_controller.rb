class WishItemsController < ApplicationController
  inherit_resources
  belongs_to :organization
  before_action :authenticate_user!, except: [:index, :list]

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

  def list
    @wish_items = params[:query].present? ? WishItem.search(params[:query]) : WishItem.all
  end

  private

  def resource_params
    return [] if request.get?
    [params.require(:wish_item).permit(:title, :reason, :description, :priority,
                                       :quantity, :unit, :organization_id, :status, :main_image)]
  end
end
