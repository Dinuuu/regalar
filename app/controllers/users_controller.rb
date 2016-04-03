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
    @gift_requests = current_user.gift_requests.pending.page(params[:page]).per(params[:per])
    @gift_items = current_user.gift_items.still_available.page(params[:page]).per(params[:per])
  end

  def pending
    @user = current_user
  end

  private

  def resource_params
    return [] if request.get?
    [params.require(:user).permit(FIELDS)]
  end
end
