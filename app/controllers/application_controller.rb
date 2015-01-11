class ApplicationController < ActionController::Base

  include Pundit
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    @campaigns = Kaminari.paginate_array(Campaign.limit(4)).page(1).per(4)
  end

  def about
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :first_name, :last_name, :password, :password_confirmation)
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def user_not_authorized
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = t("pundit.#{policy_name}.#{exception.query}",
                      default: 'You cannot perform this action.')
    redirect_to(request.referrer || root_path)
  end

end
