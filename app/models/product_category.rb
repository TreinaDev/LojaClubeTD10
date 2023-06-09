class ProductCategory < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
