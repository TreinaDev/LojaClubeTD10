class ShoppingCart < ApplicationRecord
  has_many :orderables, dependent: :destroy
  has_many :products, through: :orderables

  def total
    orderables.sum(&:total)
  end

  def total_items
    orderables.sum(&:quantity)
  end
end
