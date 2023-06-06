class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :code
      t.text :description
      t.string :brand
      t.references :product_category, null: false, foreign_key: true
      t.decimal :price

      t.timestamps
    end
  end
end
