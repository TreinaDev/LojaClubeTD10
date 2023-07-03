class AddAddressToOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :address, null: false, foreign_key: true
  end
end
