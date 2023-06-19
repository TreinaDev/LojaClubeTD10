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
end
