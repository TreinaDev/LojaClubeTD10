class Orderable < ApplicationRecord
  belongs_to :product
  belongs_to :shopping_cart

  def total
    product.price * quantity
  end
end
