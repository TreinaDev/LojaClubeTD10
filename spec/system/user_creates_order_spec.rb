require 'rails_helper'

describe 'Usuário logado acessa a página do carrinho' do
  it 'e finaliza pedido com sucesso' do
    user = create(:user, email: 'user@email.com', cpf: '30383993024')
    create(:card_info, user:, points: 999_999, conversion_tax: 20)
    shopping_cart = create(:shopping_cart)
    product_category = create(:product_category, name: 'Camisetas')
    product = create(:product, name: 'Camiseta Azul', price: 800, product_category:,
                               description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    shopping_cart.orderables.create(product:, shopping_cart:, quantity: 2)
    session = { cart_id: shopping_cart.id }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)
    order_json_data = Rails.root.join('spec/support/json/order_with_status_pending.json').read
    fake_response = double('faraday_response', status: 201, body: order_json_data)
    url = 'http://localhost:4000/api/v1/payments'
    allow(Faraday).to receive(:post).with(url).and_return(fake_response)
    json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    fake_response_two = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(fake_response_two)

    visit root_path
    login_as(user)
    click_on 'Carrinho'
    click_on 'Finalizar compra'
    fill_in 'Número do Cartão', with: '12345678901234567890'
    click_on 'Concluir compra'

    expect(current_path).to eq order_path(Order.last.id)
    expect(page).to have_content("Número do Pedido: #{Order.last.id}")
    expect(page).to have_content('Camiseta Azul')
    expect(page).to have_content('Código')
    expect(page).to have_content('CMA123456')
    expect(page).to have_content('Quantidade')
    expect(page).to have_content('2')
    expect(page).to have_content('Preço')
    expect(page).to have_content('16.000 Pontos')
    expect(page).to have_content('Subtotal')
    expect(page).to have_content('32.000 Pontos')
    expect(page).to have_content('Total do Pedido')
    expect(page).to have_content('32.000 Pontos')
    expect(page).to have_content('Desconto')
    expect(page).to have_content('0 Pontos')
    expect(page).to have_content("Data do Pedido: #{I18n.l(Order.last.created_at.to_date)}")
  end

  it 'e tenta finalizar sem informar o número cartão' do
    user = create(:user, email: 'user@email.com')
    create(:card_info, user:, points: 999_999, conversion_tax: 20)
    shopping_cart = create(:shopping_cart)
    product_category = create(:product_category, name: 'Camisetas')
    product = create(:product, name: 'Camiseta Azul', price: 800, product_category:,
                               description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    shopping_cart.orderables.create(product:, shopping_cart:, quantity: 2)
    session = { cart_id: shopping_cart.id }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)
    fake_response = double('faraday_response', status: 201, body: '[]')
    url = 'http://localhost:4000/api/v1/payments'
    allow(Faraday).to receive(:post).with(url).and_return(fake_response)
    json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    fake_response_card = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(fake_response_card)

    visit root_path
    login_as(user)
    click_on 'Carrinho'
    click_on 'Finalizar compra'
    fill_in 'Número do Cartão', with: ''
    click_on 'Concluir compra'

    expect(page).to have_content('Campo Número do Cartão não pode ser vazio.')
  end

  it 'e pedido não finaliza por erro de conexão' do
    user = create(:user, email: 'user@email.com')
    create(:card_info, user:, points: 999_999, conversion_tax: 20)
    shopping_cart = create(:shopping_cart)
    product_category = create(:product_category, name: 'Camisetas')
    product = create(:product, name: 'Camiseta Azul', price: 800, product_category:, code: 'CMA123456')

    shopping_cart.orderables.create(product:, shopping_cart:, quantity: 2)
    session = { cart_id: shopping_cart.id }

    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)

    url = 'http://localhost:4000/api/v1/payments'
    allow(Faraday).to receive(:post).with(url).and_raise(Faraday::ConnectionFailed)

    json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(fake_response)

    visit root_path
    login_as(user)

    click_on 'Carrinho'
    click_on 'Finalizar compra'
    fill_in 'Número do Cartão', with: '12345678901234567890'
    click_on 'Concluir compra'

    expect(current_path).to eq shopping_cart_path(shopping_cart)
    expect(page).to have_content('Erro de conexão - tente novamente mais tarde.')
    expect(page).to have_content('Camiseta Azul')
  end

  it 'e tenta finalizar sem endereço cadastrado' do
    user = create(:user, email: 'user@email.com', cpf: '30383993024')
    create(:card_info, user:, points: 999_999, conversion_tax: 20)
    shopping_cart = create(:shopping_cart)
    product_category = create(:product_category, name: 'Camisetas')
    product = create(:product, name: 'Camiseta Azul', price: 800, product_category:,
                               description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    shopping_cart.orderables.create(product:, shopping_cart:, quantity: 2)
    session = { cart_id: shopping_cart.id }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)
    order_json_data = Rails.root.join('spec/support/json/order_with_status_pending.json').read
    fake_response = double('faraday_response', status: 201, body: order_json_data)
    url = 'http://localhost:4000/api/v1/payments'
    allow(Faraday).to receive(:post).with(url).and_return(fake_response)
    json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    fake_response_two = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(fake_response_two)

    visit root_path
    login_as(user)
    click_on 'Carrinho'
    click_on 'Finalizar compra'
    fill_in 'Número do Cartão', with: '12345678901234567890'
    click_on 'Concluir compra'

    expect(page).to have_content 'Não pode finalizar pedido sem endereço cadastrado!'
    
  end

end
