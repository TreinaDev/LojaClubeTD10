class Product < ApplicationRecord
  belongs_to :product_category
  has_many :orderables, dependent: :destroy
  has_many :shopping_carts, through: :orderables
  has_many :favorites, dependent: :destroy
  has_many :seasonal_prices, dependent: :destroy

  has_many_attached :product_images do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end

  validates :name, :code, :description, :brand, :price, presence: true
  validates :code, format: { with: /\A[A-Za-z]{3}\d{6}\z/ }
  validates :code, uniqueness: true
  validates :price, numericality: { greater_than: 0 }
  validates :description, length: { minimum: 10 }
  validate :image_type

  def lowest_price
    if seasonal_prices.any?
      seasonal_prices.each do |sp|
        return sp.value if sp.start_date.past? && sp.end_date.future?
      end
    end
    price
  end
  
  def current_seasonal_price_find_end_date
    if seasonal_prices.any?
      seasonal_prices.each do |sp|
        return sp.end_date if sp.start_date.past? && sp.end_date.future?
      end
    end
  end

  private

  def image_type
    product_images.each do |image|
      unless image.content_type.in?(%('image/jpeg image/png'))
        errors.add(:product_images, 'precisa ser do formato JPEG ou PNG')
      end
    end
  end
end
