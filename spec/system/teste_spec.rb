require 'rails_helper'

describe 'Cria um carrinho de compras com produtos' do
  it 'deve criar um carrinho com produtos' do
    user = create(:user)
    cart = ShoppingCart.new
    category = ProductCategory.create!(name: 'Eletrônicos')
    product1 = create(:product, name: 'Produto 1', product_category: category)
    orderable = Orderable.new(product: product1, shopping_cart: cart, quantity: 2)
    orderable.save!
    cart.save!
    cart.orderables << orderable
    cart.save!
    session[:cart_id] = cart.id

    login_as(user)
    visit root_path
    click_on 'Carrinho'

    expect(cart.orderables.count).to eq(1)
    expect(cart.products[0].name).to eq 'Produto 1'
    expect(page).to have_content('Produto 1')
  end
end