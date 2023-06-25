require 'rails_helper'

describe 'Usuário acessa detalhes de um pedido' do
  it 'com sucesso como usuário dono do pedido' do
    user = create(:user, email: 'user@email.com')
    category1 = create(:product_category, name: 'Camisetas')
    product1 = create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                                description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    create(:card_info, user:)
    order = create(:order, total_value: 64_000, discount_amount: 0, final_value: 64_000, cpf: user.cpf, user:,
                           conversion_tax: 20)
    create(:order_item, order:, product: product1, quantity: 4)
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
    visit order_path(order)

    expect(page).to have_content 'Número do Pedido: 1'
    expect(page).to have_content "Data do Pedido: #{I18n.l(order.created_at.to_date)}"
    expect(page).to have_content 'Status do Pedido: Aguardando aprovação'
    expect(page).to have_content 'Camiseta Azul'
    expect(page).to have_content 'CMA123456'
    expect(page).to have_content '16.000 Pontos'
    expect(page).to have_content '64.000 Pontos'
    expect(page).to have_content '64.000 Pontos'
    expect(page).to have_content '64.000 Pontos'
  end

  it 'com sucesso como admin' do
    user = create(:user)
    create(:user, email: 'mail@punti.com', cpf: '67924052054')
    category1 = create(:product_category, name: 'Camisetas')
    product1 = create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                                description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    create(:card_info, user:)
    order = create(:order, total_value: 64_000, discount_amount: 0, final_value: 64_000, cpf: user.cpf, user:,
                           conversion_tax: 20)
    create(:order_item, order:, product: product1, quantity: 4)
    json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(fake_response)

    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail',	with: 'mail@punti.com'
    fill_in 'Senha',	with: 'password'
    within 'form' do
      click_on 'Entrar'
    end
    visit order_path(order)

    expect(page).to have_content 'Número do Pedido: 1'
    expect(page).to have_content "Data do Pedido: #{I18n.l(order.created_at.to_date)}"
    expect(page).to have_content 'Status do Pedido: Aguardando aprovação'
    expect(page).to have_content 'Camiseta Azul'
    expect(page).to have_content 'CMA123456'
    expect(page).to have_content '16.000 Pontos'
    expect(page).to have_content '64.000 Pontos'
    expect(page).to have_content '64.000 Pontos'
    expect(page).to have_content '64.000 Pontos'
  end

  it 'e não é um usuário autorizado' do
    user = create(:user)
    user_two = create(:user, email: 'cliente@email.com', cpf: '67924052054')
    category1 = create(:product_category, name: 'Camisetas')
    product1 = create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                                description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    create(:card_info, user:)
    order = create(:order, total_value: 64_000, discount_amount: 0, final_value: 64_000, cpf: user.cpf, user:,
                           conversion_tax: 20)
    create(:order_item, order:, product: product1, quantity: 4)
    json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user_two.cpf}").and_return(fake_response)

    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail',	with: 'cliente@email.com'
    fill_in 'Senha',	with: 'password'
    within 'form' do
      click_on 'Entrar'
    end
    visit order_path(order)

    expect(page).not_to have_content 'Número do Pedido: 1'
    expect(page).to have_content 'Você não possui acesso a este módulo'
    expect(current_path).to eq(root_path)
  end

  it 'e não está logado' do
    user = create(:user)
    create(:user, email: 'cliente@email.com', cpf: '67924052054')
    category1 = create(:product_category, name: 'Camisetas')
    product1 = create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                                description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    create(:card_info, user:)
    order = create(:order, total_value: 64_000, discount_amount: 0, final_value: 64_000, cpf: user.cpf, user:,
                           conversion_tax: 20)
    create(:order_item, order:, product: product1, quantity: 4)

    visit order_path(order)

    expect(page).not_to have_content 'Número do Pedido: 1'
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
    expect(current_path).to eq(new_user_session_path)
  end
end
