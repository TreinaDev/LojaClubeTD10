module ShoppingCartsHelper
  def cart_total(cart)
    if cart.nil?
      return
    else
      if cart.total_items > 0
        return cart.total_items
      else
        return 0
      end
    end
  end
end
