class OrdersController < ApplicationController
  before_action :set_order, only: %i[show]
  before_action :authenticate_user!
  before_action :order_auth, only: %i[show]

  def index; end

  def show; end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params, conversion_tax: current_user.card_info.conversion_tax, user_id: current_user.id)
    save_order_model(@order)
    flash.now[:alert] = t('.error')
    render :new
  end

  def close_order
    return if card_not_present? || card_number_blank? || card_number_length_is_invalid?

    order = build_order(@cart)

    save_order_and_redirect(order)
  end

  private

  def order_params
    params
      .require(:order)
      .permit(:total_value, :discount_amount, :final_value, :user_id, :conversion_tax)
  end

  def transfer_products(order)
    @cart.orderables.each do |o|
      OrderItem.create!(order_id: order.id, product_id: o.product_id, quantity: o.quantity)
    end
  end

  def build_order(shopping_cart)
    total_value = shopping_cart.total.round * current_user.card_info.conversion_tax.to_f
    discount = 0
    Order.new(total_value:,
              discount_amount: discount,
              final_value: total_value - discount,
              user_id: current_user.id,
              conversion_tax: current_user.card_info.conversion_tax)
  end

  def send_payment_request(order)
    Faraday.post('http://localhost:4000/api/v1/payments') do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = { payment: { cpf: current_user.cpf, card_number: params[:card_number], total_value: order.total_value,
                              descount_amount: order.discount_amount, final_value: order.final_value,
                              payment_date: I18n.l(order.created_at.to_date), order_number: order.id } }.to_json
    end
  rescue Faraday::ConnectionFailed
    nil
  end

  def save_payment_code(order, payment_response)
    response = JSON.parse(payment_response.body)
    order.update(payment_code: response['code'])
  end

  def destroy_cart
    @cart.destroy!
    session[:cart_id] = nil
  end

  def card_number_blank?
    return false if params[:card_number].present?

    redirect_to close_shopping_carts_path(@cart), alert: t('.card_number_empty')
  end

  def card_number_length_is_invalid?
    return false if params[:card_number].length == 11

    redirect_to close_shopping_carts_path(@cart), alert: t('.card_number_length_invalid')
  end

  def card_not_present?
    return false if current_user.card_info.present?

    redirect_to close_shopping_carts_path(@cart), alert: t('.card_not_present')
  end

  def save_order_and_redirect(order)
    if order.save
      transfer_products(order)
      response = send_payment_request(order)
      return redirect_to shopping_cart_path(@cart), alert: t('.connection_error') if response.nil?

      save_payment_code(order, response)

      response_redirect(response, order)
    else
      redirect_to shopping_cart_path(@cart), alert: t('.error')
    end
  end

  def response_redirect(response, order)
    if response.status == 201
      destroy_cart
      redirect_to order_path(order.id), notice: t('.success')
    else
      redirect_to shopping_cart_path(@cart), alert: t('.error')
    end
  end

  def order_auth
    return if @order.user_id == current_user.id || current_user.admin?

    redirect_to root_path, alert: t('access_denied')
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def save_order_model(order)
    return unless order.save

    transfer_products(order)
    redirect_to root_path, notice: t('.success')
  end
end
