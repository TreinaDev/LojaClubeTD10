FactoryBot.define do
  factory :card_info do
    user { create(:user) }
    conversion_tax { '20.0' }
    name { 'Gold' }
    status { 'active' }
    points { 1000 }
  end
end
