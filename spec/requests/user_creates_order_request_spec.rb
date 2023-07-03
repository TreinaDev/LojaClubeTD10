require 'rails_helper'

describe 'Usuário fecha pedido' do
  it 'com sucesso, autenticado e com cartão ativo' do
    user = create(:user, email: 'user@email.com', cpf: '30383993024')
    address = create(:address)
    create(:card_info, user:, points: 50_000)
    shopping_cart = create(:shopping_cart)
    category1 = create(:product_category, name: 'Camisetas')
    product1 = create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                                description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    shopping_cart.orderables.create(product: product1, shopping_cart:, quantity: 2)
    session = { cart_id: shopping_cart.id }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)
    order_json_data = Rails.root.join('spec/support/json/order_with_status_pending.json').read
    fake_response = double('faraday_response', status: 201, body: order_json_data)
    allow(Faraday).to receive(:post).with('http://localhost:4000/api/v1/payments').and_return(fake_response)
    json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    fake_response_card = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(fake_response_card)

    login_as(user)
    post orders_path params: { order: { card_number: '12345678901234567890', address_id: address.id } }

    expect(response).to have_http_status :found
    expect(response).to redirect_to order_path(Order.last.id)
    expect(flash[:notice]).to eq 'Pedido criado com sucesso.'
  end

  it 'sem sucesso, não estando autenticado' do
    user = create(:user, email: 'user@email.com', cpf: '30383993024')
    address = create(:address)
    create(:card_info, user:, points: 5000)
    shopping_cart = create(:shopping_cart)
    category1 = create(:product_category, name: 'Camisetas')
    product1 = create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                                description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    shopping_cart.orderables.create(product: product1, shopping_cart:, quantity: 2)
    session = { cart_id: shopping_cart.id }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)
    order_json_data = Rails.root.join('spec/support/json/order_with_status_pending.json').read
    fake_response = double('faraday_response', status: 201, body: order_json_data)
    allow(Faraday).to receive(:post).with('http://localhost:4000/api/v1/payments').and_return(fake_response)
    json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    fake_response_card = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(fake_response_card)

    post orders_path params: { order: { card_number: '12345678901234567890', address_id: address.id } }

    expect(response).to have_http_status :found
    expect(response).to redirect_to new_user_session_path
    expect(flash[:alert]).to eq 'Você precisa fazer login ou se registrar antes de continuar'
  end

  it 'sem sucesso, não possuíndo cartão ativo no clube' do
    user = create(:user, email: 'user@email.com', cpf: '30383993024')
    address = create(:address)
    shopping_cart = create(:shopping_cart)
    category1 = create(:product_category, name: 'Camisetas')
    product1 = create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                                description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    shopping_cart.orderables.create(product: product1, shopping_cart:, quantity: 2)
    session = { cart_id: shopping_cart.id }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)
    order_json_data = Rails.root.join('spec/support/json/order_with_status_pending.json').read
    fake_response = double('faraday_response', status: 201, body: order_json_data)
    allow(Faraday).to receive(:post).with('http://localhost:4000/api/v1/payments').and_return(fake_response)
    json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    fake_response_card = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(fake_response_card)

    login_as(user)
    post orders_path params: { order: { card_number: '12345678901234567890', address_id: address.id } }

    expect(response).to have_http_status :found
    expect(response).to redirect_to close_shopping_carts_path(shopping_cart.id)
    expect(flash[:alert]).to eq 'Erro de conexão - por favor, faça login novamente.'
  end

  it 'sem sucesso devido a API de pagamentos offline, autenticado e com cartão ativo' do
    user = create(:user, email: 'user@email.com', cpf: '30383993024')
    address = create(:address)
    create(:card_info, user:, points: 5000)
    shopping_cart = create(:shopping_cart)
    category1 = create(:product_category, name: 'Camisetas')
    product1 = create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                                description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    shopping_cart.orderables.create(product: product1, shopping_cart:, quantity: 2)
    session = { cart_id: shopping_cart.id }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_raise(Faraday::ConnectionFailed)
    allow(Faraday).to receive(:post).with('http://localhost:4000/api/v1/payments').and_raise(Faraday::ConnectionFailed)

    login_as(user)
    post orders_path params: { order: { card_number: '12345678901234567890', address_id: address.id } }

    expect(response).to have_http_status :found
    expect(response).to redirect_to shopping_cart_path(shopping_cart)
    expect(flash[:alert]).to eq 'Erro de conexão - tente novamente mais tarde.'
  end
end
