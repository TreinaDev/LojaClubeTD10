class OrdersController < ApplicationController
  before_action :set_order, only: %i[show]
  before_action :authenticate_user!
  before_action :order_auth, only: %i[show]

  def index; end
  def show; end

  def create
    return if card_not_present? || card_number_blank? || card_number_length_is_invalid?

    order = build_order(@cart, params[:order][:address_id])
    save_order_and_redirect(order)
  end

  private

  def build_order(shopping_cart, address_id)
    total_value = shopping_cart.total.round
    discount = shopping_cart.total.round - total_with_discount_cart(shopping_cart)

    Order.new(total_value:, discount_amount: discount, final_value: total_value - discount, user_id: current_user.id,
              conversion_tax: current_user.card_info.conversion_tax, address_id:)
  end

  def transfer_products(order)
    @cart.orderables.each do |orderable|
      OrderItem.create(order_id: order.id, product_id: orderable.product_id, quantity: orderable.quantity,
                       price_amount: orderable.product.price, discount_amount: orderable.product.discount(@company))
    end
  end

  def send_payment_request(order)
    Faraday.post('http://localhost:4000/api/v1/payments') do |req|
      req.body = { payment: { cpf: current_user.cpf, card_number: params[:order][:card_number],
                              total_value: order.total_value,
                              descount_amount: order.discount_amount,
                              final_value: order.final_value,
                              payment_date: Time.zone.now.to_date, order_number: order.id } }.to_json
      req.headers = { 'Content-Type': 'application/json' }
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

  def save_order_and_redirect(order)
    if order.save
      transfer_products(order)
      response = send_payment_request(order)
      return (order.destroy && redirect_to(shopping_cart_path(@cart), alert: t('.connection_error'))) if response.nil?

      response_redirect(response, order)
    else
      redirect_to shopping_cart_path(@cart), alert: (order.address.nil? ? t('.address_required') : t('.error'))
    end
  end

  def response_redirect(response, order)
    if response.status == 201
      destroy_cart
      save_payment_code(order, response)
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

  def total_with_discount_cart(cart)
    cart.orderables.sum { |orderable| orderable.product.lowest_price(@company) * orderable.quantity }
  end

  def card_number_blank?
    return false if params[:order][:card_number].present?

    redirect_to close_shopping_carts_path(@cart), alert: t('.card_number_empty')
  end

  def card_number_length_is_invalid?
    return false if params[:order][:card_number].length == 20

    redirect_to close_shopping_carts_path(@cart), alert: t('.card_number_length_invalid')
  end

  def card_not_present?
    return false if current_user.card_info.present?

    redirect_to close_shopping_carts_path(@cart), alert: t('.card_not_present')
  end
end
