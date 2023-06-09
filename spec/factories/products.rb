FactoryBot.define do
  factory :product do
    name { 'MyString' }
    code { 'ABC123456' }
    description { 'Descrição do produto' }
    brand { 'MyString' }
    product_category { nil }
    price { '9.99' }
  end
end
