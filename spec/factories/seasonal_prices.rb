FactoryBot.define do
  factory :seasonal_price do
    product { create(:product) }
    start_date { 1.week.from_now.to_date }
    end_date { 2.weeks.from_now.to_date }
    value { 100.99 }
  end
end
