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
  validate :seasonal_price_greater_than_price, on: :update, if: :price_changed?

  def discounts?
    product_category.promotional_campaigns.any? || seasonal_prices.any?
  end

  private

  def seasonal_price_greater_than_price
    has_greater = seasonal_prices.any? do |seasonal_price|
      seasonal_price.value >= price && (seasonal_price.ongoing? || seasonal_price.future?)
    end

    errors.add(:price, :greater_than_seasonal_price) if has_greater
  end

  def image_type
    product_images.each do |image|
      unless image.content_type.in?(%('image/jpeg image/png'))
        errors.add(:product_images, 'precisa ser do formato JPEG ou PNG')
      end
    end
  end
end
