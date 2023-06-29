class CustomerAreasController < ApplicationController
  before_action :authenticate_user!, only: %i[index me addresses update_points order_history]
  before_action :prevent_admin, only: %i[index me favorite_tab addresses update_points order_history]
  before_action :prevent_visitor, only: %i[favorite_tab addresses]

  def index; end

  def me
    @user = current_user
  end

  def addresses
    @user = current_user
  end

  def favorite_tab
    return unless user_signed_in?

    @user = current_user
    @favorites = @user.favorites
  end

  def order_history
    update_order_status
    @user_orders = current_user.orders
  end

  def update_order_status
    @user_pending_orders = current_user.orders.where(status: :pending)
    @user_pending_orders.each do |order|
      response = Faraday.get("http://localhost:4000/api/v1/payments/#{order.payment_code}")
      order.update(status: JSON.parse(response.body)['status'])
    rescue Faraday::ConnectionFailed
      flash[:alert] = t('.update_error')
    end
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
