class CreateCampaignCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :campaign_categories do |t|
      t.references :promotional_campaign, null: false, foreign_key: true
      t.references :product_category, null: false, foreign_key: true
      t.integer :discount

      t.timestamps
    end
  end
end
