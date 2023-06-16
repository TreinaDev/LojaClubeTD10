class ShoppingCartsController < ApplicationController
  before_action :set_shopping_cart, only: %i[add remove]
  before_action :set_product_and_quantity, only: [:add]

  def show
    @shopping_cart = ShoppingCart.find(session[:cart_id])
  end

  def add
    current_orderable = @shopping_cart.orderables.find_by(product_id: @product.id)

    if current_orderable
      update_quantity(current_orderable)
    else
      create_orderable
    end
  end

  def remove
    Orderable.find_by(id: params[:id]).destroy
    if @shopping_cart.orderables.count <= 0
      @shopping_cart.destroy
      session[:cart_id] = nil
      return redirect_to root_path
    end
    redirect_to @shopping_cart
  end

  private

  def set_product_and_quantity
    @product = Product.find(params[:id])
    @quantity = params[:quantity].to_i
  end

  def set_shopping_cart
    @shopping_cart = ShoppingCart.find_by(id: session[:cart_id])
    return unless @shopping_cart.nil?

    @shopping_cart = ShoppingCart.create
    session[:cart_id] = @shopping_cart.id
  end

  def update_quantity(current_orderable)
    if current_orderable.update(quantity: @quantity)
      redirect_to @shopping_cart, notice: t('.success')
    elsif request.referer == shopping_cart_url(@shopping_cart)
      redirect_to @shopping_cart, alert: t('.error')
    end
  end

  def create_orderable
    shopping = @shopping_cart.orderables.new(product: @product, quantity: @quantity)

    if shopping.save
      redirect_to @shopping_cart, notice: t('.add_success')
    else
      @shopping_cart.destroy if @shopping_cart.orderables.blank?
      redirect_to @product, alert: t('.error')
    end
  end
end
