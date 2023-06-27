class CreateSeasonalPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :seasonal_prices do |t|
      t.references :product, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.decimal :value

      t.timestamps
    end
  end
end
