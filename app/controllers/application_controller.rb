class ApplicationController < ActionController::Base
  include ActiveSupport::NumberHelper

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_product_categories
  before_action :load_cart

  private

  def prevent_admin
    return unless user_signed_in? && current_user.admin?

    redirect_to root_path, alert: t(:prevent_admin_message)
  end

  def prevent_visitor
    return if user_signed_in?

    redirect_to new_user_session_path, alert: t('prevent_logged_out_visitor')
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name cpf phone_number])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name phone_number])
  end

  def load_product_categories
    @product_categories = ProductCategory.where('active = true')
  end

  def check_user
    return if current_user.admin?

    redirect_to root_path, alert: t('access_denied')
  end

  def load_cart
    @cart = ShoppingCart.find_by(id: session[:cart_id])
  end
end
