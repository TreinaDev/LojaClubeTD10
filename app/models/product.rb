class Product < ApplicationRecord
  belongs_to :product_category
  has_one_attached :product_image

  validates :name, :code, :description, :brand, :price, presence: true
  validates :code, format: { with: /\A[A-Za-z]{3}\d{6}\z/ }
  validates :code, uniqueness: true
  validates :price, numericality: { only_integer: true, greater_than: 0 }
  validates :description, length: { minimum: 10 }
end
