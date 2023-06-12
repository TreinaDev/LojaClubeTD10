class AddIndexCodeToProducts < ActiveRecord::Migration[7.0]
  def change
    add_index :products, :code, unique: true
  end
end
