FactoryBot.define do
  factory :address do
    address { 'Rua Dr. Alcides Pereira' }
    number { '111' }
    city { 'Maruim' }
    state { 'Sergipe' }
    zipcode { '49770000' }
  end
end
