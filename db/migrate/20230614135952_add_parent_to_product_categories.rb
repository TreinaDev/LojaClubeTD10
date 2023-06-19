class AddParentToProductCategories < ActiveRecord::Migration[7.0]
  def change
    add_reference :product_categories, :parent, null: true, foreign_key: { to_table: :product_categories }
  end
end
