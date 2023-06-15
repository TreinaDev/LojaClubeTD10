require 'rails_helper'

describe 'Usuário adiciona produto ao carrinho' do
  it 'apenas estando autenticado' do
    category1 = create(:product_category, name: 'Camisetas')
    create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                     description: 'Uma camisa azul muito bonita', code: 'CMA123456')

    visit root_path
    click_on 'Camiseta Azul'

    expect(page).not_to have_content 'Quantidade'
    expect(page).not_to have_button 'Comprar'
    expect(page).not_to have_field 'number_field'
  end
  it 'com sucesso' do
    user = create(:user)
    category1 = create(:product_category, name: 'Camisetas')
    create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                     description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    login_as(user)
    visit root_path
    click_on 'Camiseta Azul'
    click_on 'Comprar'

    expect(current_path).to eq shopping_cart_path(1)
    expect(page).to have_content 'Carrinho de compras'
    expect(page).to have_content 'Camiseta Azul'
    expect(page).to have_content 'Valor em pontos: 800'
    expect(page).to have_content 'Quantidade'
    expect(page).to have_field 'quantity', with: '1'
    expect(page).to have_content 'Total:'
    expect(page).to have_content '800 pontos'
  end
  it 'com sucesso, e consegue continuar comprando' do
    user = create(:user)
    category1 = create(:product_category, name: 'Camisetas')
    create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                     description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    login_as(user)
    visit root_path
    click_on 'Camiseta Azul'
    click_on 'Comprar'
    click_on 'Continuar comprando'

    expect(current_path).to eq root_path
  end
end
