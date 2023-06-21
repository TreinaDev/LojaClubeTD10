module ShoppingCartsHelper
  def cart_total(cart)
    return if cart.nil?
    return cart.total_items if cart.total_items.positive?
  end
end
