class UsersController < ApplicationController
  inherit_resources

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

  def gift_items_and_requests
    @gift_requests = paginate(current_user.gift_requests)
    @gift_items = paginate(current_user.gift_items.still_available)
  end

  def pending
    @user = current_user
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
