require 'rails_helper'

describe 'Usuário adiciona produto ao carrinho' do
  it 'com sucesso, estando autenticado, e possuindo cartão ativo' do
    user = create(:user)
    category1 = create(:product_category, name: 'Camisetas')
    product = create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                               description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    create(:card_info, user:)
    session_user = { status_user: 'unblocked' }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session_user)

    login_as(user)
    post add_shopping_carts_path params: { id: product.id.to_s, quantity: '1' }

    expect(response).to have_http_status :found
    expect(response).to redirect_to shopping_cart_path(ShoppingCart.last.id)
    expect(flash[:notice]).to eq 'Adicionado produto ao carrinho'
  end
  it 'sem sucesso, não estando autenticado' do
    category1 = create(:product_category, name: 'Camisetas')
    product = create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                               description: 'Uma camisa azul muito bonita', code: 'CMA123456')

    post add_shopping_carts_path params: { id: product.id.to_s, quantity: '1' }

    expect(response).to redirect_to new_user_session_path
    expect(flash[:alert]).to eq 'Você precisa fazer login ou se registrar antes de continuar'
  end
  it 'sem sucesso, sendo administrador' do
    user = create(:user, email: 'jose@punti.com')
    category1 = create(:product_category, name: 'Camisetas')
    product = create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                               description: 'Uma camisa azul muito bonita', code: 'CMA123456')

    login_as(user)
    post add_shopping_carts_path params: { id: product.id.to_s, quantity: '1' }

    expect(response).not_to redirect_to shopping_cart_path(ShoppingCart.last.id)
    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq 'Administrador não tem acesso a essa página'
  end
  it 'sem sucesso, não possuindo cartão ativo no clube' do
    user = create(:user, cpf: '97559017010')
    category1 = create(:product_category, name: 'Camisetas')
    product = create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                               description: 'Uma camisa azul muito bonita', code: 'CMA123456')

    login_as(user)
    post add_shopping_carts_path params: { id: product.id.to_s, quantity: '1' }

    expect(response).not_to redirect_to shopping_cart_path(ShoppingCart.last.id)
    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq 'Usuário não é permitido realizar compras na loja'
  end
  it 'com sucesso, possuindo CPF ativo como funcionário' do
    user = create(:user)
    category = create(:product_category, name: 'Camisetas')
    product = create(:product, name: 'Camiseta Azul', price: 800, product_category: category,
                               description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    create(:card_info, user:)
    session_user = { status_user: 'unblocked' }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session_user)

    login_as(user)
    post add_shopping_carts_path params: { id: product.id.to_s, quantity: '1' }

    expect(response).not_to redirect_to root_path
    expect(response).to redirect_to shopping_cart_path(ShoppingCart.last.id)
    expect(response).to have_http_status :found
    expect(flash[:notice]).to eq 'Adicionado produto ao carrinho'
  end
  it 'sem sucesso estando autenticado, mas sem CPF ativo como funcionário' do
    user = create(:user)
    category = create(:product_category, name: 'Camisetas')
    product = create(:product, name: 'Camiseta Azul', price: 800, product_category: category,
                               description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    create(:card_info, user:)
    session_user = { status_user: 'fired' }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session_user)

    login_as(user)
    post add_shopping_carts_path params: { id: product.id.to_s, quantity: '1' }

    expect(response).to redirect_to root_path
    expect(response).not_to redirect_to shopping_cart_path(ShoppingCart.last.id)
    expect(flash[:alert]).to eq 'Usuário não é permitido realizar compras na loja'
  end
end
