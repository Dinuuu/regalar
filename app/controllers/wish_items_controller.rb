class WishItemsController < OrganizationAuthenticationController
  include OrganizationMailerHelper
  inherit_resources
  defaults resource_class: WishItem, collection_name: 'wish_items', instance_name: 'wish_item',
           finder: :find_by_slug_or_id
  belongs_to :organization
  before_action :authenticate_user!, except: [:index, :list, :show]
  before_action :chek_authentication_for_organization, only: [:create, :destroy, :pause, :resume]
  before_action :check_eliminated, only: [:destroy]
  def index
    @wish_items = WishItem.for_organization(@organization).not_eliminated
    index!
  end

  def destroy
    wish_item.eliminate
    wish_item.donations.pending.each do |donation|
      donation.destroy
      send_cancelation_email(donation, cancelation_params[:reason])
    end
    redirect_to :back
  end

  def create
    create! { @organization }
  end

  def list
    @wish_items = WishItem.not_eliminated
    @wish_items = params[:query].present? ? @wish_items.search(params[:query]) : @wish_items
  end

  def pause
    wish_item.pause
    redirect_to :back
  end

  def resume
    wish_item.resume
    redirect_to :back
  end

  def show
    @comment = Comment.new(commentable: WishItem.find_by_slug_or_id(params[:id]))
    show!
  end

  private

  def wish_item
    @wish_item ||= WishItem.find_by_slug_or_id(params[:id])
  end

  def check_eliminated
    return true unless wish_item.eliminated?
    render status: :forbidden,
           text: 'The request is already eliminated'
  end

  def resource_params
    return [] if request.get?
    [params.require(:wish_item).permit(:title, :reason, :description, :priority, :active,
                                       :quantity, :obtained, :unit, :organization_id, :main_image,
                                       :finish_date, :weight, :measures)]
  end

  def cancelation_params
    params.require(:donation).permit(:reason)
  end
end
