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
  context 'autenticado' do
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
    it 'com quantidade acima de um, com sucesso' do
      user = create(:user)
      category1 = create(:product_category, name: 'Camisetas')
      create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                      description: 'Uma camisa azul muito bonita', code: 'CMA123456')
      login_as(user)
      visit root_path
      click_on 'Camiseta Azul'
      fill_in 'number_field', with: '4'
      click_on 'Comprar'

      expect(current_path).to eq shopping_cart_path(1)
      expect(page).to have_content 'Carrinho de compras'
      expect(page).to have_content 'Camiseta Azul'
      expect(page).to have_content 'Valor em pontos: 800'
      expect(page).to have_content 'Quantidade'
      expect(page).to have_field 'quantity', with: '4'
      expect(page).to have_content 'Total:'
      expect(page).to have_content '3200 pontos'
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
    it 'e mais de um produto diferente, com sucesso' do
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

      expect(current_path).to eq shopping_cart_path(1)
      expect(page).to have_content 'Carrinho de compras'
      expect(page).to have_content 'Camiseta Azul'
      expect(page).to have_content 'Valor em pontos: 800'
      expect(page).to have_content 'Quantidade'
      expect(page).to have_field 'quantity', with: '1'
      expect(page).to have_content 'Camiseta Azul'
      expect(page).to have_content 'Valor em pontos: 100'
      expect(page).to have_content 'Quantidade'
      expect(page).to have_field 'quantity', with: '1'
      expect(page).to have_content 'Total:'
      expect(page).to have_content '900 pontos'
    end
    it 'sem sucesso, ao informar 0 como quantidade' do
      user = create(:user)
      category1 = create(:product_category, name: 'Camisetas')
      create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                      description: 'Uma camisa azul muito bonita', code: 'CMA123456')
      login_as(user)
      visit root_path
      click_on 'Camiseta Azul'
      fill_in 'number_field', with: '0'
      click_on 'Comprar'

      expect(current_path).not_to eq shopping_cart_path(1)
      expect(page).to have_content 'Não pode adicionar produto sem quantidade!'
    end
  end
end
