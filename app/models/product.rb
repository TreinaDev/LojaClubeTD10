class Product < ApplicationRecord
  belongs_to :product_category
  has_many :orderables, dependent: :destroy
  has_many :shopping_carts, through: :orderables
  has_many :favorites, dependent: :destroy
  has_many :seasonal_prices, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items

  has_many_attached :product_images do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end

  validates :name, :code, :description, :brand, :price, presence: true
  validates :code, format: { with: /\A[A-Za-z]{3}\d{6}\z/ }
  validates :code, uniqueness: true
  validates :price, numericality: { greater_than: 0 }
  validates :description, length: { minimum: 10 }
  validate :image_type

  def lowest_price(company)
    [current_seasonal_price&.value, price_by_promotional_campaign(company), price].compact.min
  end

  def current_seasonal_price
    return unless seasonal_prices.any?

    seasonal_prices.each do |sp|
      return sp if sp.ongoing?
    end
  end

  private

  def price_by_promotional_campaign(company)
    return if company.nil? || company.class != Company

    pcs = company.promotional_campaigns.filter(&:in_progress?)
    return if pcs.empty?

    promotional = find_promotional_campaign_for_product(pcs)
    get_price_by_campaign(promotional) || price
  end

  def get_price_by_campaign(promotional)
    return unless promotional

    category = product_category.parent_if_exists
    campaign_category = promotional.campaign_categories.find_by(product_category: category)
    campaign_category ? price - ((campaign_category.discount * price) / 100) : price
  end

  def find_promotional_campaign_for_product(promotional_campaigns)
    category = product_category.parent_if_exists

    promotional_campaigns.find do |campaign|
      campaign.campaign_categories.find_by(product_category: category)
    end
  end

  def image_type
    product_images.each do |image|
      unless image.content_type.in?(%('image/jpeg image/png'))
        errors.add(:product_images, 'precisa ser do formato JPEG ou PNG')
      end
    end
  end
end
