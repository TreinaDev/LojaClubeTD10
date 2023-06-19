class AddTypeToProductCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :product_categories, :type, :string
  end
end
