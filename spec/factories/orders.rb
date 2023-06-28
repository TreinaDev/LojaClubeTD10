FactoryBot.define do
  factory :order do
    total_value { 1000 }
    discount_amount { 0 }
    final_value { 1000 }
    user { create(:user) }
    conversion_tax { 20 }
  end
end
