class AddPaymentCodeToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :payment_code, :string
  end
end
