require 'rails_helper'

describe 'Usuário remove produto do carrinho' do
  it 'apenas estando autenticado' do
    visit shopping_cart_path(1)

    expect(current_path).to eq new_user_session_path
  end
  it 'com sucesso, e é redirecionado para página inicial' do
    user = create(:user)
    category1 = create(:product_category, name: 'Camisetas')
    create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                     description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    create(:card_info, user:)
    session_user = { status_user: 'unblocked' }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session_user)

    login_as(user)
    visit root_path
    click_on 'Camiseta Azul'
    click_on 'Adicionar ao carrinho'
    click_on 'Remover'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Produto removido com sucesso'
    expect(ShoppingCart.last).to eq nil
  end
  it 'mais de um produto e permanece no carrinho, com sucesso' do
    user = create(:user)
    category1 = create(:product_category, name: 'Camisetas')
    create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                     description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    create(:product, name: 'Camiseta Vermelha', price: 100, product_category: category1,
                     description: 'Uma camisa vermelha muito grande', code: 'ZDS123789')
    create(:card_info, user:)
    session_user = { status_user: 'unblocked' }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session_user)

    login_as(user)
    visit root_path
    click_on 'Camiseta Azul'
    click_on 'Adicionar ao carrinho'
    click_on 'Continuar comprando'
    click_on 'Camiseta Vermelha'
    click_on 'Adicionar ao carrinho'
    find('#ZDS123789').click

    expect(current_path).to eq shopping_cart_path(1)
    expect(page).to have_content 'Produto removido com sucesso'
    expect(page).to have_content 'Camiseta Azul'
    expect(page).to have_content 'Total: 16.000'
    expect(page).not_to have_content 'Camiseta Vermelha'
  end
  it 'todos de uma vez, com sucesso' do
    user = create(:user)
    cart = create(:shopping_cart)
    category1 = create(:product_category, name: 'Camisetas')
    product1 = create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                                description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    product2 = create(:product, name: 'Camiseta Vermelha', price: 100, product_category: category1,
                                description: 'Uma camisa vermelha muito grande', code: 'ZDS123789')
    product3 = create(:product, name: 'Camiseta Verde', price: 500, product_category: category1,
                                description: 'Uma camisa verde muito grande', code: 'ATY123789')
    cart.orderables.create(product: product1, shopping_cart: cart, quantity: 2)
    cart.orderables.create(product: product2, shopping_cart: cart, quantity: 2)
    cart.orderables.create(product: product3, shopping_cart: cart, quantity: 2)
    session = { cart_id: cart.id }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)

    login_as(user)
    visit root_path
    click_on 'Carrinho'
    click_on 'Limpar carrinho'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Produtos removidos com sucesso'
    expect(page).not_to have_link 'Carrinho'
  end
  it 'e ao sair da aplicação, carrinho é destruído' do
    user = create(:user)
    category1 = create(:product_category, name: 'Camisetas')
    create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                     description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    create(:card_info, user:)
    session_user = { status_user: 'unblocked' }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session_user)

    login_as(user)
    visit root_path
    click_on 'Camiseta Azul'
    click_on 'Adicionar ao carrinho'
    click_on 'Continuar comprando'
    click_on 'Sair'

    expect(ShoppingCart.all).to be_empty
  end
end
