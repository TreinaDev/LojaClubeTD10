require 'rails_helper'

describe 'Usuário vê os preços em pontos' do
  it 'e sendo um visitante, não vê preço' do
    category = create(:product_category, name: 'Eletrodomestico')
    create(:product, name: 'Geladeira branca', code: 'GLD678456', description: 'Geladeira bonita',
                     price: 200, product_category: category)

    visit root_path

    within('#recent_products.carousel') do
      within('.card#GLD678456') do
        expect(page).not_to have_content '200'
        expect(page).not_to have_content 'Pontos'
      end
    end
  end
  it 'e sendo usuário autenticado com cartão ativo vê os pontos' do
    user = create(:user, email: 'user@email.com', cpf: '30383993024')
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

    expect(user.card_info.conversion_tax).to eq '20.0'
    expect(user.card_info.status).to eq 'active'
    expect(page).to have_content 'O seu cartão está ativo, vamos às compras.'
    expect(page).to have_content '4.000 Pontos'
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
    expect(page).not_to have_content '4.000 Pontos'
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
    expect(page).not_to have_content '4.000 Pontos'
  end
  it 'enquanto administrador e sem cartão ativo vê os preços em reais' do
    admin = create(:user, email: 'admin@punti.com')
    category = create(:product_category, name: 'Eletrodomestico')
    create(:product, name: 'Geladeira branca', code: 'GLD678456', description: 'Geladeira bonita',
                     price: 200, product_category: category)
    fake_response = double('faraday_response', status: 404, body: { errros: 'Cartão não encontrado' })
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{admin.cpf}").and_return(fake_response)

    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail',	with: 'admin@punti.com'
    fill_in 'Senha',	with: 'password'
    within 'form' do
      click_on 'Entrar'
    end

    expect(page).to have_content 'Geladeira branca'
    expect(page).to have_content 'Geladeira bonita'
    expect(page).to have_content 'R$ 200,00'
    expect(page).not_to have_content '4.000 Pontos'
  end
  it 'enquanto administrador e com cartão ativo vê os preços em reais' do
    admin = create(:user, email: 'admin@punti.com', cpf: '30383993024')
    category = create(:product_category, name: 'Eletrodomestico')
    create(:product, name: 'Geladeira branca', code: 'GLD678456', description: 'Geladeira bonita',
                     price: 200, product_category: category)
    json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{admin.cpf}").and_return(fake_response)

    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail',	with: 'admin@punti.com'
    fill_in 'Senha',	with: 'password'
    within 'form' do
      click_on 'Entrar'
    end

    expect(page).to have_content 'Geladeira branca'
    expect(page).to have_content 'Geladeira bonita'
    expect(page).to have_content 'R$ 200,00'
    expect(page).not_to have_content '4.000 Pontos'
  end
end
