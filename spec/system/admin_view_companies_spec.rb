require 'rails_helper'

describe 'Admin visualiza todas as empresas' do
  it 'na página de empresas com sucesso' do
    admin = create(:user, email: 'adm@punti.com')
    json_data = Rails.root.join('spec/support/json/companies.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/companies').and_return(fake_response)

    login_as(admin)
    visit root_path
    click_on 'Empresas'

    expect(page).to have_content '57806849000174'
    expect(page).to have_content '89987772000172'
    expect(page).to have_content 'Rebase'
    expect(page).to have_content 'Vindi'
    expect(page).to have_content 'Rebase LTDA.'
    expect(page).to have_content 'Vindi LTDA.'
  end

  it 'e não existem empresas' do
    admin = create(:user, email: 'adm@punti.com')
    fake_response = double('faraday_response', status: 200, body: '[]')
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/companies').and_return(fake_response)

    login_as(admin)
    visit root_path
    click_on 'Empresas'

    expect(current_path).to eq companies_path
    expect(page).to have_content 'Nenhuma empresa nova encontrada'
  end

  it 'e não consegue ver as empresas' do
    admin = create(:user, email: 'adm@punti.com')
    fake_response = double('faraday_response', status: 500, body: '{}')
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/companies').and_return(fake_response)

    login_as(admin)
    visit root_path
    click_on 'Empresas'

    expect(current_path).to eq companies_path
    expect(page).to have_content 'Erro interno - Empresas não carregadas'
  end
end
