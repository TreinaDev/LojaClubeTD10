class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, :price_amount, :discount_amount, numericality: { greater_than: 0 }
  validates :price_amount, presence: true
  validates :discount_amount, numericality: { less_than: :price_amount }
  validate :block_changes, on: :update

  private

  def block_changes
    errors.add(:base, 'Pedido não pode ser modificado')
  end
end
