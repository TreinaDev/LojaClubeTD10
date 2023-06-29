require 'rails_helper'

describe 'Usuário vê o saldo de pontos' do
  it 'na área do cliente, estando autenticado e com cartão ativo' do
    user = create(:user)
    category = create(:product_category, name: 'Eletrodoméstico')
    create(:product, name: 'Geladeira branca', code: 'GLD678456', description: 'Geladeira bonita',
                     price: 200, product_category: category)
    company_json_data = Rails.root.join('spec/support/json/cpf_active_company.json').read
    company_fake_response = double('faraday_response', status: 200, body: company_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:3000/api/v1/employee_profiles?cpf=#{user.cpf}").and_return(company_fake_response)
    card_json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    card_fake_response = double('faraday_response', status: 200, body: card_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(card_fake_response)

    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: user.email
    fill_in 'Senha', with: user.password
    within 'form' do
      click_on 'Entrar'
    end
    click_on 'Área do Cliente'

    expect(page).to have_content 'Saldo atual: 1.000 Pontos'
  end
  it 'enquanto visitante sem cartão ativo não vê os pontos na área do cliente' do
    user = create(:user, email: 'user@email.com', cpf: '30383993024')
    category = create(:product_category, name: 'Eletrodoméstico')
    create(:product, name: 'Geladeira branca', code: 'GLD678456', description: 'Geladeira bonita',
                     price: 200, product_category: category)
    company_json_data = Rails.root.join('spec/support/json/cpf_active_company.json').read
    company_fake_response = double('faraday_response', status: 200, body: company_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:3000/api/v1/employee_profiles?cpf=#{user.cpf}").and_return(company_fake_response)
    card_fake_response = double('faraday_response', status: 404, body: { errors: 'Cartão não encontrado' })
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(card_fake_response)

    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: user.email
    fill_in 'Senha', with: user.password
    within 'form' do
      click_on 'Entrar'
    end
    click_on 'Área do Cliente'

    expect(page).not_to have_content 'Saldo atual: 500 Pontos'
    expect(page).to have_content 'Saldo atual: 0 Pontos'
  end
end
