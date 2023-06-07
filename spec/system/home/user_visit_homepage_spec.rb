require 'rails_helper'

describe 'Usuário visita homepage' do
  it 'e vê nome o nome da loja' do
    visit root_path

    expect(page).to have_content 'Loja do Clube'
    expect(page).to have_link 'Loja do Clube', href: root_path
  end

  it 'e vê uma barra de navegação' do
    visit root_path

    expect(page).to have_button 'Categorias'
    expect(page).to have_link 'Entrar', href: new_user_session_path
    expect(page).to have_css 'nav'
  end

  it 'e vê os produtos listados' do
    category = ProductCategory.create!(name: 'Camisetas')
    FactoryBot.create(:product, name: 'Camiseta Azul', price: 800, product_category: category)
    FactoryBot.create(:product, name: 'Camiseta Vermelha', price: 701, product_category: category)

    visit root_path

    expect(page).to have_content 'Produtos'
    expect(page).to have_content 'Camiseta Azul'
    expect(page).to have_content '800 Pontos'
    expect(page).to have_content 'Camiseta Vermelha'
    expect(page).to have_content '701 Pontos'
  end
end
