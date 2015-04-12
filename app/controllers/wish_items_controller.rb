class WishItemsController < OrganizationAuthenticationController
  inherit_resources
  belongs_to :organization
  before_action :authenticate_user!, except: [:index, :list]
  before_action :chek_authentication_for_organization, only: [:create, :destroy, :stop, :resume]

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

  def stop
    @wish_item = WishItem.find(params[:id])
    @wish_item.stop
    redirect_to organization_wish_item_path(@wish_item.organization, @wish_item)
  end

  def resume
    @wish_item = WishItem.find(params[:id])
    @wish_item.resume
    redirect_to organization_wish_item_path(@wish_item.organization, @wish_item)
  end

  private

  def resource_params
    return [] if request.get?
    [params.require(:wish_item).permit(:title, :reason, :description, :priority, :active,
                                       :quantity, :obtained, :unit, :organization_id, :main_image)]
  end
end
