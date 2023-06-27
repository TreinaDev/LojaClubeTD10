class ProductCategory < ApplicationRecord
  has_many :products, dependent: :restrict_with_error
  has_many :campaign_categories, dependent: :restrict_with_error
  has_many :promotional_campaigns, through: :campaign_categories
  has_many :subcategories,
           class_name: 'ProductSubcategory',
           foreign_key: :parent_id,
           dependent: :destroy,
           inverse_of: :parent

  validates :name, presence: true, uniqueness: true
  after_validation :set_type

  private

  def set_type
    self.type = 'ProductCategory'
  end

  def delete_campaign_category
    campaign_categories.each(&:destroy) unless active?
  end
end
