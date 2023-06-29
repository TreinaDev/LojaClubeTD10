class RemoveCpfFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :cpf, :string
  end
end
