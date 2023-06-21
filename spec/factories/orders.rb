FactoryBot.define do
  factory :order do
    order_number { 1 }
    total_value { 1000 }
    discount_amount { '10.0' }
    final_value { 90 }
    cpf { '09777513097' }
    card_number { 123_456_789 }
    payment_date { Time.zone.today.to_s }
    user { create(:user) }
  end
end
