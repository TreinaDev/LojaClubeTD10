class Orderable < ApplicationRecord
  belongs_to :product
  belongs_to :shopping_cart

  validates :quantity, numericality:  { greater_than: 0 }

  def total
    product.price * quantity
  end
end
