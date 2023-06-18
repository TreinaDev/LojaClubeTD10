FactoryBot.define do
  factory :client_address do
    user { nil }
    address { nil }
    default { false }
  end
end
