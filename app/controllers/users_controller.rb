class UsersController < ApplicationController
  inherit_resources

  defaults resource_class: User, collection_name: 'users', instance_name: 'user',
           finder: :find_by_slug_or_id

  before_action :authenticate_user!, except: [:index, :show]

  FIELDS = [:first_name, :last_name, :email, :avatar, :password, :password_confirmation]

  def update_password
    if current_user.update_attributes(resource_params.first)
      sign_in(current_user, bypass: true)
      @user = current_user
      render :show
    else
      render :edit_password
    end
  end

  def wishes_and_gifts
    @gift_requests = paginate(current_user.gift_requests.pending)
    @gift_items = paginate(current_user.gift_items.still_available.not_eliminated)
    @donations = paginate(current_user.donations.pending)
  end

  def pending
    @user = current_user
  end

  def organizations
    @my_organizations = current_user.organizations
  end

  private

  def paginate(relation)
    relation.page(params[:page]).per(params[:per])
  end

  def resource_params
    return [] if request.get?
    [params.require(:user).permit(FIELDS)]
  end
end
