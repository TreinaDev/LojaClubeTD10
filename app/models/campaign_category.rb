class CampaignCategory < ApplicationRecord
  belongs_to :promotional_campaign
  belongs_to :product_category

  validates :discount, presence: true
end
