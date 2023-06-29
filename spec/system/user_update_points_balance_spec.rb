require 'rails_helper'

describe 'Usuário atualiza o saldo de pontos' do
  it 'sempre que faz o login, automaticamente' do
    user = create(:user, email: 'user@email.com', cpf: '30383993024')
    category = create(:product_category, name: 'Eletrodoméstico')
    create(:product, name: 'Geladeira branca', code: 'GLD678456', description: 'Geladeira bonita',
                     price: 200, product_category: category)
    create(:card_info, user:, points: 5000)
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
    expect(page).not_to have_content 'Saldo atual: 5.000 Pontos'
  end
  it 'manualmente na área do cliente, com sucesso' do
    user = create(:user, email: 'user@email.com', cpf: '30383993024')
    create(:card_info, user:, points: 5000)
    card_json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    card_fake_response = double('faraday_response', status: 200, body: card_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(card_fake_response)

    login_as(user)
    visit customer_areas_path
    find('#update_points').click

    expect(page).to have_content 'Saldo de pontos atualizado!'
    expect(page).to have_content 'Saldo atual: 1.000 Pontos'
    expect(page).not_to have_content 'Saldo atual: 5.000 Pontos'
  end
  it 'e não consegue manualmente, pois não possui cartão' do
    user = create(:user, email: 'user@email.com', cpf: '30383993024')
    card_fake_response = double('faraday_response', status: 404, body: { errors: 'Cartão não encontrado' })
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(card_fake_response)

    login_as(user)
    visit customer_areas_path
    find('#update_points').click

    expect(page).to have_content 'Saldo atual: 0 Pontos'
    expect(page).to have_content 'Cartão não encontrado. Impossível atualizar saldo!'
  end
  it 'manualmente, porém a API de cartões está fora' do
    user = create(:user, email: 'user@email.com', cpf: '30383993024')
    create(:card_info, user:, points: 5000)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_raise(Faraday::ConnectionFailed)

    login_as(user)
    visit customer_areas_path
    find('#update_points').click

    expect(page).to have_content 'Saldo atual: 5.000 Pontos'
    expect(page).to have_content 'Não foi possível atualizar o saldo, tente mais tarde.'
  end
end
