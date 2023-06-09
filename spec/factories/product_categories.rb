FactoryBot.define do
  factory :product_category do
    sequence :name do |n|
      "Categoria Teste #{n}"
    end
    active { true }
  end
end
