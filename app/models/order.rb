class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  def subtotal_price
    subtotal = 0
    order_items.each do |order_item|
      subtotal += order_item.product.price * order_item.quantity
    end
    subtotal
  end
end
