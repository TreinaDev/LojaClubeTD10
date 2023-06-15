FactoryBot.define do
  factory :product do
    name { 'Celular' }
    code { 'ABC123456' }
    description { 'Descrição do produto' }
    brand { 'Samsung' }
    product_category { nil }
    price { '500' }
  end
end
