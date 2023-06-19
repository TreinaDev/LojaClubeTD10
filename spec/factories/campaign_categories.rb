FactoryBot.define do
  factory :campaign_category do
    promotional_campaign { create(:promotional_campaign) }
    product_category { create(:product_category) }
    discount { 10 }
  end
end
