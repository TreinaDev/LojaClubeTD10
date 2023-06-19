class ShoppingCart < ApplicationRecord
  has_many :orderables, dependent: :destroy
  has_many :products, through: :orderables

  def total
    orderables.sum(&:total)
  end

  def total_items
    sum = 0
    orderables.sum(&:quantity)
    sum
  end
end
