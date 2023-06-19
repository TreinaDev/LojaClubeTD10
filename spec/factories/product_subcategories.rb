FactoryBot.define do
  factory :product_subcategory do
    sequence :name do |n|
      "Subcategoria de produtos #{n}"
    end

    parent { FactoryBot.create(:product_category) }
  end
end
