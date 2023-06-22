class RemoveStreetFromAddresses < ActiveRecord::Migration[7.0]
  def change
    remove_column :addresses, :street, :string
  end
end
