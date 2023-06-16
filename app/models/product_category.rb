class ProductCategory < ApplicationRecord
  after_validation :set_type

  has_many :subcategories,
           class_name: 'ProductSubcategory',
           foreign_key: :parent_id,
           dependent: :destroy,
           inverse_of: :parent

  validates :name, presence: true, uniqueness: true

  private

  def set_type
    self.type = 'ProductCategory'
  end
end
