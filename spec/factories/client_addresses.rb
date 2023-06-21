FactoryBot.define do
  factory :client_address do
    user { create(:user) }
    address { create(:address) }
    default { false }
  end
end
