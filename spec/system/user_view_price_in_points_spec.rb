require 'rails_helper'

describe 'Usuário vê os preços em pontos' do
  it 'estando com cartão ativo' do
    user = create(:user, email: 'user@email.com')
    category = create(:product_category, name: 'Eletrodomestico')
    create(:product, name: 'Geladeira branca', code: 'GLD678456', description: 'Geladeira bonita',
                     price: 200, product_category: category)
    json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(fake_response)

    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail',	with: 'user@email.com'
    fill_in 'Senha',	with: 'password'
    within 'form' do
      click_on 'Entrar'
    end

    expect(page).to have_content 'O seu cartão está ativo, vamos às compras.'
  end
  it 'estando com cartão inativo' do
    user = create(:user, email: 'user@email.com')
    category = create(:product_category, name: 'Eletrodomestico')
    create(:product, name: 'Geladeira branca', code: 'GLD678456', description: 'Geladeira bonita',
                     price: 200, product_category: category)
    json_data = Rails.root.join('spec/support/json/card_data_inactive.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(fake_response)

    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail',	with: 'user@email.com'
    fill_in 'Senha',	with: 'password'
    within 'form' do
      click_on 'Entrar'
    end

    expect(page).to have_content 'O seu cartão não está ativo, entre em contato com sua empresa.'
  end
  it 'não possuíndo cartão' do
    user = create(:user, email: 'user@email.com')
    category = create(:product_category, name: 'Eletrodomestico')
    create(:product, name: 'Geladeira branca', code: 'GLD678456', description: 'Geladeira bonita',
                     price: 200, product_category: category)
    fake_response = double('faraday_response', status: 404, body: { errros: 'Cartão não encontrado' })
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(fake_response)

    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail',	with: 'user@email.com'
    fill_in 'Senha',	with: 'password'
    within 'form' do
      click_on 'Entrar'
    end

    expect(page).to have_content 'Logado com sucesso. Você não tem cartão ativo no nosso clube!'
  end
end
