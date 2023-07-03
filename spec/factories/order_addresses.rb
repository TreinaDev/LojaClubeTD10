FactoryBot.define do
  factory :order_address do
    order { create(:order) }
    address { 'Rua Principal' }
    number { '100' }
    city { 'Constatinópoles' }
    state { 'Paraisópoles' }
    zipcode { '12345678' }
  end
end
