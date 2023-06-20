FactoryBot.define do
  factory :order do
    order_number { 1 }
    total_value { 1 }
    discount_amount { "9.99" }
    final_value { 1 }
    cpf { "MyString" }
    card_number { 1 }
    payment_date { "MyString" }
    user { nil }
    shopping_cart { nil }
  end
end
