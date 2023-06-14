class Product < ApplicationRecord
  belongs_to :product_category
  has_many :orderables, dependent: :destroy
  has_many :shopping_carts, through: :orderables

  has_many_attached :product_images do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end

  validates :name, :code, :description, :brand, :price, presence: true
  validates :code, format: { with: /\A[A-Za-z]{3}\d{6}\z/ }
  validates :code, uniqueness: true
  validates :price, numericality: { greater_than: 0 }
  validates :description, length: { minimum: 10 }
  validate :image_type

  private

  def image_type
    product_images.each do |image|
      unless image.content_type.in?(%('image/jpeg image/png'))
        errors.add(:product_images, 'precisa ser do formato JPEG ou PNG')
      end
    end
  end
end
