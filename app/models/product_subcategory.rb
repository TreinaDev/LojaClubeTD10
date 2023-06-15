class ProductSubcategory < ProductCategory
  belongs_to :parent, class_name: 'ProductCategory'
end
