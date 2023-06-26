class CampaignCategory < ApplicationRecord
  belongs_to :promotional_campaign
  belongs_to :product_category

  validates :discount, presence: true

  def self.select_only_active_categories
    joins(:product_category).where(product_categories: { active: true })
  end
end
