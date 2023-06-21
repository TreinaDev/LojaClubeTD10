FactoryBot.define do
  factory :product do
    name { 'Celular Branco' }
    code { 'ABC123456' }
    description { 'Descrição do produto' }
    brand { 'Samsung' }
    product_category { create(:product_category) }
    price { '500' }
  end
end
