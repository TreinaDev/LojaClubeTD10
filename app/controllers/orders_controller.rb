class OrdersController < ApplicationController
  def index; end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
  end

  def create
    conversion_tax = 20.7
    @order = Order.new(order_params, conversion_tax:)
    @order.user_id = current_user.id
    if @order.save
      transfer_products(@order)
      return redirect_to root_path, notice: t('order.create.success')
    end
    flash.now[:alert] = t('order.create.error')
    render :new
  end

  def close_order
    shopping_cart = ShoppingCart.find_by(id: session[:cart_id])
    order = Order.new(total_value: shopping_cart.total.round, discount_amount: 0,
                      final_value: shopping_cart.total.round, cpf: current_user.cpf, user_id: current_user.id)
    if order.save
      response = Faraday.post('http://localhost:4000/api/v1/payment') do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = { payment_details: { cpf: order.cpf,
                                        card_number: params[:card_number],
                                        total_value: order.total_value,
                                        discount_amount: order.discount_amount,
                                        final_value: order.final_value,
                                        order_date: I18n.l(order.created_at.to_date),
                                        order_number: order.id } }.to_json
      end
    else
      flash.now[:alert] = t('order.create.error')
      redirect_to shopping_cart_path
    end
    if response.status == 200
      order.save
      transfer_products(order)
      session[:cart_id] = nil
      redirect_to order_path(order.id), notice: t('order.create.success')
    else
      flash.now[:alert] = t('order.create.error')
      redirect_to shopping_cart_path
    end
  end

  private

  def order_params
    params
      .require(:order)
      .permit(:order_number, :total_value, :discount_amount, :final_value,
              :cpf, :card_number, :payment_date, :user_id, :shopping_cart_id)
  end

  def transfer_products(order)
    @cart.orderables.each do |o|
      OrderItem.create!(order_id: order.id, product_id: o.product_id, quantity: o.quantity)
    end
    @cart.destroy!
  end
end
