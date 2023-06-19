FactoryBot.define do
  factory :orderable do
    product { create(:product) }
    shopping_cart { create(:shopping_cart) }
    quantity { 1 }
  end
end
