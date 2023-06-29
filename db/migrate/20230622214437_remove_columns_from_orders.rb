class RemoveColumnsFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :order_number, :integer
    remove_column :orders, :card_number, :integer
    remove_column :orders, :payment_date, :string
  end
end
