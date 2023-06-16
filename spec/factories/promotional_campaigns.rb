FactoryBot.define do
  factory :promotional_campaign do
    name { 'Natal 2023' }
    start_date { 1.week.from_now }
    end_date { 2.months.from_now }
  end
end
