class CreateCardInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :card_infos do |t|
      t.references :user, null: false, foreign_key: true
      t.string :conversion_tax
      t.string :name
      t.string :status
      t.integer :points

      t.timestamps
    end
  end
end
