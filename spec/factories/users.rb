FactoryBot.define do
  factory :user do
    name { 'José' }
    email { 'josé@gmail.com' }
    password { 'jose1234' }
    cpf { '89913704030' }
    phone_number { '85940028922' }
  end
end
