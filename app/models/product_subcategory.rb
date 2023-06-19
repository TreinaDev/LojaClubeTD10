class ProductSubcategory < ProductCategory
  belongs_to :parent, class_name: 'ProductCategory', inverse_of: :subcategories

  private

  def set_type
    self.type = 'ProductSubcategory'
  end
end
