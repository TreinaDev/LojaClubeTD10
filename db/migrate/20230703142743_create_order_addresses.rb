class CreateOrderAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :order_addresses do |t|
      t.references :order, null: false, foreign_key: true
      t.string :address
      t.string :number
      t.string :city
      t.string :state
      t.string :zipcode

      t.timestamps
    end
  end
end
