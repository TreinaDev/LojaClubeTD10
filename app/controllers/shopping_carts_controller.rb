class ShoppingCartsController < ApplicationController
  before_action :set_product_and_quantity, only: [:add]
  before_action :set_shopping_cart, only: %i[add remove]
  before_action :authenticate_user!
  before_action :prevent_admin, only: [:add]

  def show
    @shopping_cart = ShoppingCart.find(session[:cart_id])
  end

  def add
    if @shopping_cart
      current_orderable = @shopping_cart.orderables.find_by(product_id: @product.id)
      if current_orderable
        update_quantity(current_orderable)
      else
        create_orderable
      end
    else
      redirect_to @product, alert: t('.add_error')
    end
  end

  def remove
    Orderable.find_by(id: params[:id]).destroy
    if @shopping_cart.orderables.count <= 0
      @shopping_cart.destroy
      session[:cart_id] = nil
      return redirect_to root_path, notice: t('.remove_success')
    end
    redirect_to @shopping_cart, notice: t('.remove_success')
  end

  def remove_all
    @shopping_cart = ShoppingCart.find_by(id: session[:cart_id])
    @shopping_cart.orderables.each(&:destroy)
    @shopping_cart.destroy
    session[:cart_id] = nil
    redirect_to root_path, notice: t('.success_remove_all')
  end

  private

  def set_product_and_quantity
    @product = Product.find(params[:id])
    @quantity = params[:quantity].to_i
  end

  def set_shopping_cart
    @shopping_cart = ShoppingCart.find_by(id: session[:cart_id])
    return unless @shopping_cart.nil? && @quantity.positive?

    @shopping_cart = ShoppingCart.create
    session[:cart_id] = @shopping_cart.id
  end

  def update_quantity(current_orderable)
    if current_orderable.update(quantity: @quantity)
      return redirect_to @shopping_cart, notice: t('.update_success')
    elsif request.referer == shopping_cart_url(@shopping_cart)
      return redirect_to @shopping_cart, alert: t('.update_error')

    end

    redirect_to @product, alert: t('.add_error')
  end

  def create_orderable
    shopping = @shopping_cart.orderables.new(product: @product, quantity: @quantity)

    if shopping.save
      redirect_to @shopping_cart, notice: t('.add_success')
    else
      redirect_to @product, alert: t('.add_error')
    end
  end
end
