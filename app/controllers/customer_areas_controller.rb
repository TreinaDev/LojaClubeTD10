class CustomerAreasController < ApplicationController
  before_action :authenticate_user!, only: %i[index me addresses update_points order_history extract_tab]
  before_action :prevent_admin, only: %i[index me favorite_tab addresses update_points order_history extract_tab]
  before_action :prevent_visitor, only: %i[favorite_tab addresses]
  before_action :update_order_status, only: %i[order_history]

  def index; end

  def me
    @user = current_user
  end

  def addresses
    @user = current_user
  end

  def extract_tab
    card_response = current_user.find_card
    card = JSON.parse(card_response.body)
    extract_response = Faraday.get("http://localhost:4000/api/v1/extracts?card_number=#{card['number']}")
    response_body = JSON.parse(extract_response.body)
    @operations = response_body if extract_response.status == 200 && response_body.is_a?(Array)
  rescue Faraday::ConnectionFailed
    flash.now[:alert] = t('.failed')
    @error_message = 'Não foi possível obter informações do extrato deste cartão.'
  end

  def favorite_tab
    return unless user_signed_in?

    @user = current_user
    @favorites_active = Favorite.joins(:product)
                                .where(user: @user, products: { active: true })
    @favorites_inactive = Favorite.joins(:product)
                                  .where(user: @user, products: { active: false })
  end

  def order_history
    @user_orders = current_user.orders
  end

  def update_order_status
    set_pending_orders
    @user_pending_orders.each do |order|
      response = Faraday.get("http://localhost:4000/api/v1/payments/#{order.payment_code}")
      order.update(status: JSON.parse(response.body)['status'])
    rescue Faraday::ConnectionFailed
      flash[:alert] = t('.update_error')
    end
  end

  def set_pending_orders
    @user_pending_orders = current_user.orders.where(status: :pending).filter { |o| !o.payment_code.nil? }
  end

  def update_points
    begin
      response = current_user.find_card
    rescue StandardError
      return redirect_to customer_areas_path, alert: t('.failed')
    end
    return redirect_to customer_areas_path, alert: t('.not_found') if response.status == 404

    update_point(response)
  end

  private

  def update_point(response)
    @data = JSON.parse(response.body)
    current_user.card_info.update!(points: @data['points'])
    redirect_to customer_areas_path, notice: t('.success')
  end
end
