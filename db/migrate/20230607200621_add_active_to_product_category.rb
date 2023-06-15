class AddActiveToProductCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :product_categories, :active, :boolean, default: true
  end
end
