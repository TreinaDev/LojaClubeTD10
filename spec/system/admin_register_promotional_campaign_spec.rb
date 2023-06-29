require 'rails_helper'

describe 'Admin registra uma nova Campanha Promocional' do
  it 'e as empresas do select são carregadas com sucesso, e recebe mensagem quando nova empresa é adicionada' do
    admin = create(:user, email: 'adm@punti.com')
    create(:company, brand_name: 'Empresa Existente', registration_number: '58771187000107',
                     corporate_name: 'Empresa Existente LTDA')
    json_data = Rails.root.join('spec/support/json/companies.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/companies').and_return(fake_response)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    click_on 'Nova Campanha Promocional'

    expect(page).to have_select 'Empresa', with_options: ['Apple', 'Empresa Existente', 'Microsoft']
    expect(page).to have_content 'Empresas carregadas com sucesso, e nova empresa encontrada'
  end

  it 'e as empresas inativas do select não são carregadas, e recebe mensagem quando nova empresa é adicionada' do
    admin = create(:user, email: 'adm@punti.com')
    company = create(:company, brand_name: 'Empresa Existente', registration_number: '58771187000107',
                               corporate_name: 'Empresa Existente LTDA')
    json_data = Rails.root.join('spec/support/json/companies.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/companies').and_return(fake_response)
    Company.find(company.id).update(active: false)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    click_on 'Nova Campanha Promocional'

    expect(page).to have_select 'Empresa', with_options: %w[Apple Microsoft]
    expect(page).to have_content 'Empresas carregadas com sucesso, e nova empresa encontrada'
  end

  it 'e recebe mensagem quando nenhuma nova empresa encontrada, mas situação da empresa é atualizada para false' do
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
    click_on 'Campanhas'
    click_on 'Nova Campanha Promocional'

    expect(page).to have_select 'Empresa', with_options: %w[Apple Microsoft]
    expect(page).to have_content 'Empresas carregadas com sucesso, mas nenhuma nova empresa encontrada'
  end

  it 'e não existem empresas' do
    admin = create(:user, email: 'adm@punti.com')
    fake_response = double('faraday_response', status: 204, boby: '[]')
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/companies').and_return(fake_response)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    click_on 'Nova Campanha Promocional'

    expect(page).to have_content 'Solicitação efetuada com sucesso, mas nenhuma empresa encontrada'
    expect(page).to have_content 'Nenhuma empresa encontrada na aplicação de Gestão de Empresas'
  end

  it 'e não consegue ver as empresas por erro 500' do
    admin = create(:user, email: 'adm@punti.com')
    fake_response = double('faraday_response', status: 500, body: '{}')
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/companies').and_return(fake_response)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    click_on 'Nova Campanha Promocional'

    expect(page).to have_content 'Erro interno. Tente mais tarde. Não foi possível carregar novas empresas'
  end

  it 'com sucesso' do
    admin = create(:user, email: 'admin@punti.com')
    create(:company)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    click_on 'Nova Campanha Promocional'
    fill_in 'Nome', with: 'Verão 2023'
    fill_in 'Data Inicial', with: 1.week.from_now.to_date
    fill_in 'Data Final', with: 1.month.from_now.to_date
    select 'CodeCampus', from: 'Empresa'
    click_on 'Cadastrar'

    expect(page).to have_content 'Campanha Promocional'
    expect(page).to have_content 'Campanha Promocional cadastrada com sucesso'
    expect(page).to have_content 'Campanha Verão 2023'
    expect(page).to have_content 'Empresa Participante CodeCampus'
    expect(page).to have_content 'Adicionar Categorias à Campanha'
  end

  it 'com dados incompletos' do
    admin = create(:user, email: 'admin@punti.com')
    create(:company)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    click_on 'Nova Campanha Promocional'
    fill_in 'Nome', with: ''
    fill_in 'Data Inicial', with: ''
    fill_in 'Data Final', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content 'Não foi possível cadastrar a Campanha Promocional'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Empresa é obrigatório(a)'
    expect(page).to have_content 'Data Inicial não pode ficar em branco'
    expect(page).to have_content 'Data Final não pode ficar em branco'
  end

  it 'como visitante tenta acessar, mas é direcionado para logar' do
    visit new_promotional_campaign_path

    expect(current_path).to eq new_user_session_path
    expect(page).not_to have_field('Nome')
    expect(page).not_to have_field('Nome Fantasia', with: 'CodeCampus')
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end

  it 'como usuário comum tenta acessar, mas não tem acesso e é direcionado para o root' do
    user = create(:user)

    login_as(user)
    visit new_promotional_campaign_path

    expect(current_path).to eq root_path
    expect(page).not_to have_field('Nome')
    expect(page).not_to have_field('Nome Fantasia', with: 'CodeCampus')
    expect(page).to have_content 'Você não possui acesso a este módulo'
  end
end
