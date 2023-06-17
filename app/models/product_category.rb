class ProductCategory < ApplicationRecord
  has_many :products, dependent: :destroy
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
end
