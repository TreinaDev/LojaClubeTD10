module IndexHelper
  def show_price(product)
    return unless user_signed_in?

    content_tag(:p, "#{product.price.round} Pontos")
  end
end
