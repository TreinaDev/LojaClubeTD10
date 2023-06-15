class ShoppingCartsController < ApplicationController
  before_action :set_shopping_cart, only: %i[add remove]
  before_action :params_product, only: %i[add]

  def show
    @shopping_cart = ShoppingCart.find(session[:cart_id])
  end

  def add
    quantity = params[:quantity].to_i
    current_orderable = @shopping_cart.orderables.find_by(product_id: @product.id)
    if current_orderable && quantity.positive?
      current_orderable.update(quantity:)
    elsif quantity <= 0
      current_orderable.destroy
    else
      @shopping_cart.orderables.create(product: @product, quantity:)
    end
    redirect_to @shopping_cart
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

  def params_product
    @product = Product.find(params[:id])
  end

  def set_shopping_cart
    @shopping_cart = ShoppingCart.find_by(id: session[:cart_id])
    return unless @shopping_cart.nil?

    @shopping_cart = ShoppingCart.create
    session[:cart_id] = @shopping_cart.id
  end
end
