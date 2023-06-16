class ShoppingCartsController < ApplicationController
  before_action :set_shopping_cart, only: %i[add remove]
  before_action :params_product, only: %i[add]

  def show
    @shopping_cart = ShoppingCart.find(session[:cart_id])
  end

  def add
    quantity = params[:quantity].to_i
    current_orderable = @shopping_cart.orderables.find_by(product_id: @product.id)
    if current_orderable
      if current_orderable.update(quantity:)
        flash[:alert] = "Alterado quantidade do produto"
        redirect_to @shopping_cart
      else
        flash[:alert] = "Não pode adicionar produto sem quantidade!"
        redirect_to @shopping_cart
      end
    else
      shopping = @shopping_cart.orderables.new(product: @product, quantity:)
      if shopping.save
        redirect_to @shopping_cart
      else
        @shopping_cart.destroy if !@shopping_cart.orderables.present?
        redirect_to @product, alert: "Não pode adicionar produto sem quantidade!"
      end
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
