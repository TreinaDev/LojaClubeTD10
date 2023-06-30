class AddDiscountAmountToOrderItem < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :discount_amount, :decimal, default: 0
    add_column :order_items, :price_amount, :decimal, default: 0
  end
end
