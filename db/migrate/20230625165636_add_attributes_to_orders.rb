class AddAttributesToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :conversion_tax, :float
    add_column :orders, :status, :integer, default: 0
  end
end
