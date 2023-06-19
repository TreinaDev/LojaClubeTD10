class ProductCategory < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :products, dependent: :restrict_with_error
  has_many :campaign_categories, dependent: :restrict_with_error
  has_many :promotional_campaigns, through: :campaign_categories
end
