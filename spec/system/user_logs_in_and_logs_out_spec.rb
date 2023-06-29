require 'rails_helper'

describe 'Usuário entra no sistema' do
  it 'e faz login' do
    user = create(:user, email: 'zezinho@mail.com', password: 'f4k3p455w0rd')
    card_json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    card_fake_response = double('faraday_response', status: 200, body: card_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(card_fake_response)
    company_json_data = Rails.root.join('spec/support/json/cpf_active_company.json').read
    company_fake_response = double('faraday_response', status: 200, body: company_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:3000/api/v1/employee_profiles?cpf=#{user.cpf}").and_return(company_fake_response)

    visit new_user_session_path

    within 'form#new_user' do
      fill_in 'E-mail', with: 'zezinho@mail.com'
      fill_in 'Senha', with: 'f4k3p455w0rd'
      click_on 'Entrar'
    end

    expect(page).to have_content 'Logado com sucesso.'
    expect(page).to have_button 'Sair'
  end

  it 'e ao fazer login, a API de cartões atualiza as informações do cartão quando necessário' do
    user = create(:user, email: 'zezinho@mail.com', password: 'f4k3p455w0rd')
    create(:card_info, user:, conversion_tax: '50.0')
    card_json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    card_fake_response = double('faraday_response', status: 200, body: card_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(card_fake_response)
    company_json_data = Rails.root.join('spec/support/json/cpf_active_company.json').read
    company_fake_response = double('faraday_response', status: 200, body: company_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:3000/api/v1/employee_profiles?cpf=#{user.cpf}").and_return(company_fake_response)

    visit new_user_session_path
    within 'form#new_user' do
      fill_in 'E-mail', with: 'zezinho@mail.com'
      fill_in 'Senha', with: 'f4k3p455w0rd'
      click_on 'Entrar'
    end

    user.card_info.reload
    expect(user.card_info.conversion_tax).to eq '20.0'
    expect(page).to have_content 'Logado com sucesso.'
    expect(page).to have_button 'Sair'
  end

  it 'e tenta fazer login com informações incorretas' do
    create(:user, email: 'zezinho@mail.com', password: 'f4k3p455w0rd')

    visit new_user_session_path
    within 'form#new_user' do
      fill_in 'E-mail', with: 'zezezinho@mail.com'
      fill_in 'Senha', with: 'f4k3p455w0rd'
      click_on 'Entrar'
    end

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'E-mail ou senha inválidos.'
    expect(page).not_to have_button 'Sair'
  end

  it 'e ao fazer login retorna uma mensagem de erro quando a API de empresa está fora' do
    create(:user, email: 'zezinho@mail.com', password: 'f4k3p455w0rd', cpf: '30383993024')
    category = create(:product_category)
    create(:product, name: 'Geladeira branca', code: 'GLD678456', description: 'Geladeira bonita',
                     price: 200, product_category: category)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/employee_profiles?cpf=30383993024').and_raise(Faraday::ConnectionFailed)

    visit new_user_session_path
    within 'form#new_user' do
      fill_in 'E-mail', with: 'zezinho@mail.com'
      fill_in 'Senha', with: 'f4k3p455w0rd'
      click_on 'Entrar'
    end

    expect(current_path).to eq root_path
    expect(page).to have_content 'Error interno! Logado como visitante. Seus dados podem estar desatualizados!'
    expect(page).to have_content '(Visitante) zezinho@mail.com'
    expect(page).not_to have_content 'administrador'
  end

  it 'e faz logout' do
    user = create(:user)

    login_as user
    visit root_path
    click_on 'Sair'

    expect(page).to have_content 'Até breve!'
  end
end
