class AddDefaultAddressToClientAddresses < ActiveRecord::Migration[7.0]
  def change
    add_column :client_addresses, :default, :boolean, default: false
  end
end
