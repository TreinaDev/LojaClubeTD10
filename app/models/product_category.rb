class ProductCategory < ApplicationRecord
  has_many :products, dependent: :destroy
end
