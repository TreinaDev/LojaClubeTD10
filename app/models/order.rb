class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :total_value, :final_value, numericality: { greater_than: 0 }
  validates :discount_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :conversion_tax, presence: true
  validate :block_changes, on: :update

  enum status: { pending: 0, approved: 1, rejected: 2 }

  def subtotal_price
    order_items.sum do |order_item|
      order_item.price_amount * order_item.quantity
    end
  end

  def block_changes
    errors.add(:base, 'Pedido não pode ser modificado')
  end
end
