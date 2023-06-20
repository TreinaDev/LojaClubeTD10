class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :order_number
      t.integer :total_value
      t.integer :discount_amount, default: 0
      t.integer :final_value
      t.string :cpf
      t.integer :card_number
      t.string :payment_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
