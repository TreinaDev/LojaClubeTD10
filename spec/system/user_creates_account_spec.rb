require 'rails_helper'

describe 'Usuário entra no sistema' do
  it 'e cria uma conta' do
    company_json_data = Rails.root.join('spec/support/json/cpf_active_company.json').read
    company_fake_response = double('faraday_response', status: 200, body: company_json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/employee_profiles?cpf=26502001033').and_return(company_fake_response)
    card_json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    card_fake_response = double('faraday_response', status: 200, body: card_json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/cards/26502001033').and_return(card_fake_response)

    visit new_user_registration_path
    fill_in 'Nome', with: 'João'
    fill_in 'E-mail', with: 'joao@ig.com.br'
    fill_in 'CPF', with: '26502001033'
    fill_in 'Número de telefone', with: '19999999999'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme a senha', with: 'password'
    click_on 'Registrar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Bem vindo!'
    expect(page).not_to have_content 'administrador'
  end

  it 'e cria uma conta com o CPF ativo na empresa à qual pertence' do
    card_json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    card_fake_response = double('faraday_response', status: 200, body: card_json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/cards/98746307010').and_return(card_fake_response)
    company_json_data = Rails.root.join('spec/support/json/cpf_active_company.json').read
    card_fake_response = double('faraday_response', status: 200, body: company_json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/employee_profiles?cpf=98746307010').and_return(card_fake_response)

    visit new_user_registration_path
    fill_in 'Nome', with: 'Felipe'
    fill_in 'E-mail', with: 'felipe@gmail.com'
    fill_in 'CPF', with: '98746307010'
    fill_in 'Número de telefone', with: '50118301012'
    fill_in 'Senha', with: 'f4k3p455w0rd'
    fill_in 'Confirme a senha', with: 'f4k3p455w0rd'
    click_on 'Registrar'

    expect(current_path).to eq root_path
    expect(page).to have_content '(Funcionário ativo) felipe@gmail.com'
  end

  it 'e cria conta com CPF bloqueado na empresa à qual pertence' do
    company_json_data = Rails.root.join('spec/support/json/cpf_inactive_company.json').read
    company_fake_response = double('faraday_response', status: 200, body: company_json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/employee_profiles?cpf=98746307010').and_return(company_fake_response)
    card_json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    card_fake_response = double('faraday_response', status: 200, body: card_json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/cards/98746307010').and_return(card_fake_response)

    visit new_user_registration_path
    fill_in 'Nome', with: 'Felipe'
    fill_in 'E-mail', with: 'felipe@gmail.com'
    fill_in 'CPF', with: '98746307010'
    fill_in 'Número de telefone', with: '50118301012'
    fill_in 'Senha', with: 'f4k3p455w0rd'
    fill_in 'Confirme a senha', with: 'f4k3p455w0rd'
    click_on 'Registrar'

    expect(current_path).to eq root_path
    expect(page).to have_content '(Funcionário bloqueado) felipe@gmail.com'
  end

  it 'e cria uma conta mesmo que tenha sido demitido da empresa à qual pertence' do
    company_json_data = Rails.root.join('spec/support/json/cpf_fired_company.json').read
    company_fake_response = double('faraday_response', status: 200, body: company_json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/employee_profiles?cpf=98746307010').and_return(company_fake_response)
    card_json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    card_fake_response = double('faraday_response', status: 200, body: card_json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/cards/98746307010').and_return(card_fake_response)

    visit new_user_registration_path
    fill_in 'Nome', with: 'Felipe'
    fill_in 'E-mail', with: 'felipe@gmail.com'
    fill_in 'CPF', with: '98746307010'
    fill_in 'Número de telefone', with: '50118301012'
    fill_in 'Senha', with: 'f4k3p455w0rd'
    fill_in 'Confirme a senha', with: 'f4k3p455w0rd'
    click_on 'Registrar'

    expect(current_path).to eq root_path
    expect(page).to have_content '(Ex-funcionário) felipe@gmail.com'
  end

  it 'e cria uma conta com cartão ativo na empresa' do
    company_json_data = Rails.root.join('spec/support/json/cpf_active_company.json').read
    company_fake_response = double('faraday_response', status: 200, body: company_json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/employee_profiles?cpf=30383993024').and_return(company_fake_response)
    card_json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    card_fake_response = double('faraday_response', status: 200, body: card_json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/cards/30383993024').and_return(card_fake_response)

    visit new_user_registration_path
    fill_in 'Nome', with: 'João'
    fill_in 'E-mail', with: 'joao@ig.com.br'
    fill_in 'CPF', with: '30383993024'
    fill_in 'Número de telefone', with: '19999999999'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme a senha', with: 'password'
    click_on 'Registrar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Bem vindo! O seu cartão está ativo, vamos às compras.'
    expect(page).to have_content '(Funcionário ativo) joao@ig.com.br'
    expect(page).not_to have_content 'administrador'
  end

  it 'e cria uma conta mesmo que não tenha um cartão ativo na empresa' do
    category = create(:product_category)
    create(:product, name: 'Geladeira branca', code: 'GLD678456', description: 'Geladeira bonita',
                     price: 200, product_category: category)
    json_data = Rails.root.join('spec/support/json/cpf_active_company.json').read
    company_fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/employee_profiles?cpf=26502001033').and_return(company_fake_response)
    card_fake_response = double('faraday_response', status: 404, body: { errors: 'Cartão não encontrado' })
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/cards/26502001033').and_return(card_fake_response)

    visit new_user_registration_path
    fill_in 'Nome', with: 'João'
    fill_in 'E-mail', with: 'joao@ig.com.br'
    fill_in 'CPF', with: '26502001033'
    fill_in 'Número de telefone', with: '19999999999'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme a senha', with: 'password'
    click_on 'Registrar'

    msg = 'Bem vindo! Você não tem cartão ativo no nosso clube, entre em contato com sua empresa.'
    expect(current_path).to eq root_path
    expect(page).to have_content msg
    expect(page).not_to have_content 'administrador'
  end
  it 'e ao criar uma conta ocorre erro na API de cartões' do
    category = create(:product_category)
    create(:product, name: 'Geladeira branca', code: 'GLD678456', description: 'Geladeira bonita',
                     price: 200, product_category: category)
    company_json_data = Rails.root.join('spec/support/json/cpf_active_company.json').read
    company_fake_response = double('faraday_response', status: 200, body: company_json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/employee_profiles?cpf=30383993024').and_return(company_fake_response)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/cards/30383993024').and_raise(Faraday::ConnectionFailed)

    visit new_user_registration_path
    fill_in 'Nome', with: 'João'
    fill_in 'E-mail', with: 'joao@ig.com.br'
    fill_in 'CPF', with: '30383993024'
    fill_in 'Número de telefone', with: '19999999999'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme a senha', with: 'password'
    click_on 'Registrar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Bem vindo! Ocorreu um erro interno! Seus dados podem estar desatualizados'
    expect(page).to have_content '(Visitante) joao@ig.com.br'
    expect(page).not_to have_content 'administrador'
  end

  it 'e ao criar uma conta ocorre um erro na API de empresas' do
    category = create(:product_category)
    create(:product, name: 'Geladeira branca', code: 'GLD678456', description: 'Geladeira bonita',
                     price: 200, product_category: category)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/employee_profiles?cpf=30383993024').and_raise(Faraday::ConnectionFailed)

    visit new_user_registration_path
    fill_in 'Nome', with: 'João'
    fill_in 'E-mail', with: 'joao@ig.com.br'
    fill_in 'CPF', with: '30383993024'
    fill_in 'Número de telefone', with: '19999999999'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme a senha', with: 'password'
    click_on 'Registrar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Bem vindo! Ocorreu um erro interno! Seus dados podem estar desatualizados'
    expect(page).to have_content '(Visitante) joao@ig.com.br'
  end

  it 'e cria uma conta administradora' do
    visit new_user_registration_path
    fill_in 'Nome', with: 'Adalberto'
    fill_in 'E-mail', with: 'aldaberto@punti.com'
    fill_in 'CPF', with: '73962060065'
    fill_in 'Número de telefone', with: '79981546487'
    fill_in 'Senha', with: 'f4k3p455w0rd'
    fill_in 'Confirme a senha', with: 'f4k3p455w0rd'
    click_on 'Registrar'

    expect(current_path).to eq root_path
    expect(page).to have_content '(ADMIN)'
  end

  it 'e tenta criar uma conta com informações incorretas' do
    visit new_user_registration_path
    fill_in 'Nome', with: ''
    fill_in 'E-mail', with: 'adalbertopunti.com'
    fill_in 'CPF', with: '73962060088'
    fill_in 'Número de telefone', with: '7998154648'
    fill_in 'Senha', with: 'f4k3p455w0rd'
    fill_in 'Confirme a senha', with: 'f4k3p455w0rd'
    click_on 'Registrar'

    expect(page).to have_content 'Não foi possível salvar este(a) usuário:'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'E-mail não é válido'
    expect(page).to have_content 'CPF inválido.'
    expect(page).to have_content 'Número de telefone deve conter 11 números.'
  end
end
