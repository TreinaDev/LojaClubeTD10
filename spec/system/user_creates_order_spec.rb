require 'rails_helper'

describe 'Usuário logado acessa a página do carrinho' do
  it 'e finaliza pedido com sucesso' do
    user = create(:user)
    shopping_cart = create(:shopping_cart)
    category1 = create(:product_category, name: 'Camisetas')
    product1 = create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                                description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    shopping_cart.orderables.create(product: product1, shopping_cart:, quantity: 2)
    session = { cart_id: shopping_cart.id, balance: 20_000 }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)
    fake_response = double('faraday_response', status: 200, body: '[]')
    url = 'http://localhost:4000/api/v1/payment'
    allow(Faraday).to receive(:post).with(url).and_return(fake_response)

    login_as(user)
    visit root_path
    click_on 'Carrinho'
    click_on 'Finalizar compra'
    fill_in 'Número do Cartão', with: '1234567890123456'
    click_on 'Concluir compra'

    expect(current_path).to eq order_path(Order.last.id)
    expect(page).to have_content("Número do Pedido: #{Order.last.id}")
    expect(page).to have_content('Camiseta Azul')
    expect(page).to have_content('Código')
    expect(page).to have_content('CMA123456')
    expect(page).to have_content('Quantidade')
    expect(page).to have_content('2')
    expect(page).to have_content('Valor')
    expect(page).to have_content('800')
    expect(page).to have_content('Valor Total')
    expect(page).to have_content('331 Pontos')
    expect(page).to have_content('Valor Final')
    expect(page).to have_content('298 Pontos')
    expect(page).to have_content("Data do Pedido: #{I18n.l(Order.last.created_at)}")
  end
end
