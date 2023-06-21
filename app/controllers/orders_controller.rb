class OrdersController < ApplicationController
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
