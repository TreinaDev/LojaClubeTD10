FactoryBot.define do
  factory :product do
    name { 'MyString' }
    code { 'MyString' }
    description { 'MyText' }
    brand { 'MyString' }
    product_category { nil }
    price { '9.99' }
  end
end
