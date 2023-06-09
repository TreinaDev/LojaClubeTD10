class AddIndexToProductCategoriesName < ActiveRecord::Migration[7.0]
  def change
    add_index :product_categories, :name, unique: true
  end
end
