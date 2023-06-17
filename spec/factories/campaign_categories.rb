FactoryBot.define do
  factory :campaign_category do
    promotional_campaign { nil }
    product_category { nil }
    discount { 1 }
  end
end
