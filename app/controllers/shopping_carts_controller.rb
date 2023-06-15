class ShoppingCartsController < ApplicationController

  def show
    @shopping_cart = ShoppingCart.find(session[:cart_id])
  end

  def add
    @shopping_cart ||= ShoppingCart.find_by(id: session[:cart_id])
    if @shopping_cart.nil?
      @shopping_cart = ShoppingCart.create
      session[:cart_id] = @shopping_cart.id
    end
    @product = Product.find(params[:id])
    quantity = params[:quantity].to_i
    current_orderable = @shopping_cart.orderables.find_by(product_id: @product.id)
    if current_orderable && quantity > 0
      # quantity = current_orderable.quantity + quantity
      current_orderable.update(quantity: quantity)
    elsif quantity <= 0
      current_orderable.destroy
    else
      @shopping_cart.orderables.create(product: @product, quantity: quantity)
    end
    redirect_to @shopping_cart
  end

  def remove
    @shopping_cart = ShoppingCart.find_by(id: session[:cart_id])
    Orderable.find_by(id: params[:id]).destroy
    if @shopping_cart.orderables.count <= 0
      @shopping_cart.destroy
      session[:cart_id] = nil
      return redirect_to root_path
    end
    redirect_to @shopping_cart
  end
end
