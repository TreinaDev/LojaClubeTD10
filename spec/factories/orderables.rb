FactoryBot.define do
  factory :orderable do
    product { nil }
    shopping_cart { nil }
    quantity { 1 }
  end
end
