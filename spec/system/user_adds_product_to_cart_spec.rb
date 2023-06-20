require 'rails_helper'

describe 'Usuário adiciona produto ao carrinho' do
  it 'sem sucesso, não estando autenticado' do
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
    json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    session = { card_data: JSON.parse(json_data) }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)

    login_as(user)
    visit root_path
    click_on 'Camiseta Azul'
    click_on 'Adicionar ao carrinho'

    expect(current_path).to eq shopping_cart_path(1)
    expect(page).to have_content 'Carrinho de compras'
    expect(page).to have_content 'Camiseta Azul'
    expect(page).to have_content 'Valor (pontos)'
    expect(page).to have_content '16.000'
    expect(page).to have_content 'Quantidade'
    expect(page).to have_field 'quantity', with: '1'
    expect(page).to have_content 'Total:'
    expect(page).to have_content '16.000 Pontos'
  end
  it 'e altera a quantidade com sucesso' do
    user = create(:user)
    category1 = create(:product_category, name: 'Camisetas')
    create(:product, name: 'Camiseta Azul', price: 1000, product_category: category1,
                     description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    session = { card_data: JSON.parse(json_data) }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)

    login_as(user)
    visit root_path
    click_on 'Camiseta Azul'
    click_on 'Adicionar ao carrinho'
    fill_in 'quantity',	with: '5'
    click_on 'Alterar'

    expect(current_path).to eq shopping_cart_path(1)
    expect(page).to have_content 'Alterado quantidade do produto'
    expect(page).to have_content 'Carrinho de compras'
    expect(page).to have_content 'Camiseta Azul'
    expect(page).to have_content 'Valor (pontos)'
    expect(page).to have_content '20.000'
    expect(page).to have_content 'Quantidade'
    expect(page).to have_field 'quantity', with: '5'
    expect(page).to have_content 'Total:'
    expect(page).to have_content '100.000 Pontos'
  end
  it 'e altera quantidade sem sucesso ao informar 0 como quantidade' do
    user = create(:user)
    category1 = create(:product_category, name: 'Camisetas')
    create(:product, name: 'Camiseta Azul', price: 1000, product_category: category1,
                     description: 'Uma camisa azul muito bonita', code: 'CMA123456')

    login_as(user)
    visit root_path
    click_on 'Camiseta Azul'
    click_on 'Adicionar ao carrinho'
    fill_in 'quantity',	with: '0'
    click_on 'Alterar'

    expect(current_path).to eq shopping_cart_path(1)
    expect(page).to have_content 'Não foi possível alterar quantidade de produto!'
  end
  it 'com quantidade acima de um, com sucesso' do
    user = create(:user)
    category1 = create(:product_category, name: 'Camisetas')
    create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                     description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    session = { card_data: JSON.parse(json_data) }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)

    login_as(user)
    visit root_path
    click_on 'Camiseta Azul'
    fill_in 'number_field', with: '4'
    click_on 'Adicionar ao carrinho'

    expect(current_path).to eq shopping_cart_path(1)
    expect(page).to have_content 'Carrinho de compras'
    expect(page).to have_content 'Camiseta Azul'
    expect(page).to have_content 'Valor (pontos)'
    expect(page).to have_content '16.000'
    expect(page).to have_content 'Quantidade'
    expect(page).to have_field 'quantity', with: '4'
    expect(page).to have_content 'Total:'
    expect(page).to have_content '64.000 Pontos'
  end
  it 'com sucesso, e consegue continuar comprando' do
    user = create(:user)
    category1 = create(:product_category, name: 'Camisetas')
    create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                     description: 'Uma camisa azul muito bonita', code: 'CMA123456')

    login_as(user)
    visit root_path
    click_on 'Camiseta Azul'
    click_on 'Adicionar ao carrinho'
    click_on 'Continuar comprando'

    expect(current_path).to eq root_path
  end
  it 'e mais de um produto diferente, com sucesso' do
    user = create(:user)
    category1 = create(:product_category, name: 'Camisetas')
    create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                     description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    create(:product, name: 'Camiseta Vermelha', price: 100, product_category: category1,
                     description: 'Uma camisa vermelha muito grande', code: 'ZDS123789')
    json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    session = { card_data: JSON.parse(json_data) }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)

    login_as(user)
    visit root_path
    click_on 'Camiseta Azul'
    click_on 'Adicionar ao carrinho'
    click_on 'Continuar comprando'
    click_on 'Camiseta Vermelha'
    click_on 'Adicionar ao carrinho'

    expect(current_path).to eq shopping_cart_path(1)
    expect(page).to have_content 'Carrinho de compras'
    expect(page).to have_content 'Camiseta Azul'
    expect(page).to have_content 'Valor (pontos)'
    expect(page).to have_content '16.000'
    expect(page).to have_content 'Quantidade'
    expect(page).to have_field 'quantity', with: '1'
    expect(page).to have_content 'Camiseta Azul'
    expect(page).to have_content '16.000'
    expect(page).to have_content 'Quantidade'
    expect(page).to have_field 'quantity', with: '1'
    expect(page).to have_content 'Total:'
    expect(page).to have_content '18.000 Pontos'
  end
  it 'sem sucesso, ao informar 0 como quantidade' do
    user = create(:user)
    category1 = create(:product_category, name: 'Camisetas')
    product = create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                               description: 'Uma camisa azul muito bonita', code: 'CMA123456')

    login_as(user)
    visit root_path
    click_on 'Camiseta Azul'
    fill_in 'number_field', with: '0'
    click_on 'Adicionar ao carrinho'

    expect(current_path).to eq product_path(product.id)
    expect(page).to have_content 'Não pode adicionar produto sem quantidade!'
  end
  it 'e adiciona outro produto com quantidade 0, causando um erro' do
    user = create(:user)
    category1 = create(:product_category, name: 'Camisetas')
    create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                     description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    create(:product, name: 'Camiseta Vermelha', price: 100, product_category: category1,
                     description: 'Uma camisa vermelha muito grande', code: 'ZDS123789')

    login_as(user)
    visit root_path
    click_on 'Camiseta Azul'
    click_on 'Adicionar ao carrinho'
    click_on 'Continuar comprando'
    click_on 'Camiseta Vermelha'
    fill_in 'number_field', with: '0'
    click_on 'Adicionar ao carrinho'

    expect(current_path).not_to eq shopping_cart_path(ShoppingCart.last.id)
    expect(page).to have_content 'Não pode adicionar produto sem quantidade!'
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
    click_on 'Adicionar ao carrinho'
    click_on 'Continuar comprando'
    click_on 'Camiseta Vermelha'
    click_on 'Adicionar ao carrinho'
    click_on 'Continuar comprando'
    click_on 'Camiseta Azul'
    fill_in 'quantity',	with: '0'
    click_on 'Adicionar ao carrinho'

    expect(current_path).to eq product_path(1)
    expect(page).to have_content 'Não pode adicionar produto sem quantidade!'
  end
  it 'e sendo administrador, não vê botão de comprar' do
    user = create(:user, email: 'jose@punti.com')
    category1 = create(:product_category, name: 'Camisetas')
    create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                     description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    login_as(user)
    visit root_path
    click_on 'Camiseta Azul'

    expect(page).not_to have_button 'Comprar'
  end
end
