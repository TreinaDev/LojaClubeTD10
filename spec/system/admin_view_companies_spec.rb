require 'rails_helper'

describe 'Admin visualiza as empresas' do
  it 'na página de empresas com sucesso, e recebe mensagem quando nova empresa é adicionada' do
    admin = create(:user, email: 'adm@punti.com')
    create(:company, brand_name: 'Empresa Existente', registration_number: '58771187000107',
                     corporate_name: 'Empresa Existente LTDA')
    json_data = Rails.root.join('spec/support/json/companies.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/companies').and_return(fake_response)

    login_as(admin)
    visit root_path
    click_on 'Empresas'

    expect(current_path).to eq companies_path
    within '#ativas' do
      expect(page).to have_content '12345678000195'
      expect(page).to have_content '12345678000295'
      expect(page).to have_content '58771187000107'
      expect(page).to have_content 'Apple'
      expect(page).to have_content 'Microsoft'
      expect(page).to have_content 'Empresa Existente'
      expect(page).to have_content 'Apple LTDA'
      expect(page).to have_content 'Microsoft Corporation'
      expect(page).to have_content 'Empresa Existente LTDA'
    end
    within '#inativas' do
      expect(page).to have_content '12345678000395'
      expect(page).to have_content 'IBM'
      expect(page).to have_content 'IBM Corporation'
    end
    expect(page).to have_content 'Empresas carregadas com sucesso, e nova empresa encontrada'
  end

  it 'e recebe mensagem quando nenhuma nova empresa encontrada, mas situação da empresa é atualizada' do
    admin = create(:user, email: 'adm@punti.com')
    create(:company, brand_name: 'Apple', registration_number: '12345678000195',
                     corporate_name: 'Apple LTDA')
    create(:company, brand_name: 'Microsoft', registration_number: '12345678000295',
                     corporate_name: 'Microsoft Corporation')
    create(:company, brand_name: 'IBM', registration_number: '12345678000395',
                     corporate_name: 'IBM Corporation')

    json_data = Rails.root.join('spec/support/json/companies.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/companies').and_return(fake_response)

    login_as(admin)
    visit root_path
    click_on 'Empresas'

    expect(current_path).to eq companies_path
    within '#ativas' do
      expect(page).to have_content '12345678000195'
      expect(page).to have_content '12345678000295'
      expect(page).to have_content 'Apple'
      expect(page).to have_content 'Microsoft'
      expect(page).to have_content 'Apple LTDA'
      expect(page).to have_content 'Microsoft Corporation'
    end
    within '#inativas' do
      expect(page).to have_content '12345678000395'
      expect(page).to have_content 'IBM'
      expect(page).to have_content 'IBM Corporation'
    end
    expect(page).to have_content 'Empresas carregadas com sucesso, mas nenhuma nova empresa encontrada'
  end

  it 'e não existem empresas' do
    admin = create(:user, email: 'adm@punti.com')
    fake_response = double('faraday_response', status: 204, boby: '[]')
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/companies').and_return(fake_response)

    login_as(admin)
    visit root_path
    click_on 'Empresas'

    expect(current_path).to eq companies_path
    expect(page).to have_content 'Solicitação efetuada com sucesso, mas nenhuma empresa encontrada'
  end

  it 'e não consegue ver as empresas por erro 500' do
    admin = create(:user, email: 'adm@punti.com')
    fake_response = double('faraday_response', status: 500, body: '{}')
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/companies').and_return(fake_response)

    login_as(admin)
    visit root_path
    click_on 'Empresas'

    expect(current_path).to eq companies_path
    expect(page).to have_content 'Erro interno. Tente mais tarde. Não foi possível carregar novas empresas'
  end

  it 'como visitante tenta acessar, mas é direcionado para logar' do
    visit root_path
    visit companies_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end

  it 'como usuário comum tenta acessar, mas não tem acesso e é direcionado para o root' do
    user = create(:user)

    login_as(user)
    visit root_path
    visit companies_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este módulo'
  end
end
