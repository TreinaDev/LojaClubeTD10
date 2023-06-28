class ApplicationController < ActionController::Base
  include ActiveSupport::NumberHelper

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_product_categories
  before_action :load_cart

  def bring_companies
    response = Faraday.get('http://localhost:3000/api/v1/companies')
    response_tratament(response)
  rescue StandardError
    flash.now[:alert] = t('.internal_error')
  end

  def response_tratament(response)
    case response.status
    when 200
      iterates_companies(response)
      flash_notice
    when 204
      flash.now[:notice] = t('.sucess_no_company')
    else
      flash.now[:alert] = t('.internal_error')
    end
  end

  def iterates_companies(response)
    @companies_count_before = Company.count
    companies_api = JSON.parse(response.body)
    companies_api.each do |cia|
      company = Company.find_by(registration_number: cia['registration_number'])
      unless cia['active'].nil?
        company.nil? ? create_company(cia) : update_company(cia)
      end
    end
    @companies_count_after = Company.count
  end

  def create_company(cia)
    Company.new(registration_number: cia['registration_number'],
                brand_name: cia['brand_name'],
                corporate_name: cia['corporate_name'],
                active: cia['active']).save
  end

  def update_company(cia)
    Company.find_by(registration_number: cia['registration_number']).update(brand_name: cia['brand_name'],
                                                                            corporate_name: cia['corporate_name'],
                                                                            active: cia['active'])
  end

  def flash_notice
    flash.now[:notice] = if @companies_count_before == @companies_count_after
                           t('.sucess_no_company_added')
                         else
                           t('.sucess_new_company_added')
                         end
  end

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
    @product_categories_navbar = ProductCategory.where('active = true')
  end

  def check_user
    return if user_signed_in? && current_user.admin?

    redirect_to root_path, alert: t('access_denied')
  end

  def load_cart
    @cart = ShoppingCart.find_by(id: session[:cart_id])
  end
end
