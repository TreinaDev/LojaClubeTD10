FactoryBot.define do
  factory :user do
    name { 'João Fernandes' }
    email { 'joao@ig.com.br' }
    password { 'password' }
    cpf { '20223956031' }
    phone_number { '1998555544' }
    role { 0 }
  end
end
