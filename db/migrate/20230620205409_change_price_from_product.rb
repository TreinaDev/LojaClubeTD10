class ChangePriceFromProduct < ActiveRecord::Migration[7.0]
  def change
    change_column(:products, :price, :integer)
  end
end
