class Product < ApplicationRecord
  belongs_to :product_category
  validates :name, :code, :description, :brand, :price, presence: true
end
