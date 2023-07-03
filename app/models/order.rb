class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_one :address, class_name: 'OrderAddress', dependent: :destroy

  validates :total_value, :final_value, numericality: { greater_than: 0 }
  validates :discount_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :conversion_tax, presence: true

  enum status: { pending: 0, approved: 1, rejected: 2 }

  def subtotal_price
    subtotal = 0
    order_items.each do |order_item|
      subtotal += order_item.product.price * order_item.quantity
    end
    subtotal
  end
end
