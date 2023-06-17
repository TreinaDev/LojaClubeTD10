require 'rails_helper'

describe 'Usuário vê seu carrinho de compras' do
  it 'estando logado' do
    user = create(:user)
    cart = ShoppingCart.create!
    category = ProductCategory.create!(name: 'Eletrônicos')
    product1 = create(:product, name: 'Produto 1', product_category: category)
    cart.orderables.create(product: product1, shopping_cart: cart, quantity: 2)
    session = { cart_id: cart.id }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)

    login_as(user)
    visit root_path
    click_on 'Carrinho'

    expect(current_path).to eq shopping_cart_path(cart.id)
    expect(cart.orderables.count).to eq(1)
    expect(cart.products[0].name).to eq 'Produto 1'
    expect(page).to have_content('Produto 1')
  end
  it 'não vê o carrinho de compras sem estar logado' do
    cart = ShoppingCart.create!
    category = ProductCategory.create!(name: 'Eletrônicos')
    product1 = create(:product, name: 'Produto 1', product_category: category)
    cart.orderables.create(product: product1, shopping_cart: cart, quantity: 2)
    session = { cart_id: cart.id }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)

    visit root_path
    click_on 'Carrinho'

    expect(current_path).to eq new_user_session_path
  end
  it 'sem sucesso ao adicionar um produto que já está no carrinho com quantidade zero' do
    user = create(:user)
    category1 = create(:product_category, name: 'Camisetas')
    create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                     description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    create(:product, name: 'Camiseta Vermelha', price: 100, product_category: category1,
                     description: 'Uma camisa vermelha muito grande', code: 'ZDS123789')

    login_as(user)
    visit root_path
    click_on 'Camiseta Azul'
    click_on 'Comprar'
    click_on 'Continuar comprando'
    click_on 'Camiseta Vermelha'
    click_on 'Comprar'
    click_on 'Continuar comprando'
    click_on 'Camiseta Azul'
    fill_in 'quantity',	with: '0'
    click_on 'Comprar'

    expect(current_path).to eq product_path(1)
    expect(page).to have_content 'Não pode adicionar produto sem quantidade!'
  end
end
