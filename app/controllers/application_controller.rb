class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_product_categories
  before_action :cart

  private

  def prevent_admin
    return unless current_user.admin?

    redirect_to root_path, alert: t(:prevent_admin_message)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name cpf phone_number])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name phone_number])
  end

  def load_product_categories
    @product_categories = ProductCategory.all
  end

  def check_user
    return if current_user.admin?

    redirect_to root_path, alert: t('access_denied')
  end

  def cart
    @cart = ShoppingCart.find_by(id: session[:cart_id])
  end
end
