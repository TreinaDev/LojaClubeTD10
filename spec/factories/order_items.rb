FactoryBot.define do
  factory :order_item do
    order { create(:order) }
    product { create(:product) }
    quantity { 1 }
  end
end
