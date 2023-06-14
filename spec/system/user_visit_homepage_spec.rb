require 'rails_helper'

describe 'Usuário visita homepage' do
  it 'e vê nome o nome da loja' do
    visit root_path

    expect(page).to have_content 'Loja do Clube'
    expect(page).to have_link 'Loja do Clube', href: root_path
  end
  it 'e vê uma barra de navegação' do
    visit root_path

    expect(page).to have_link 'Categorias'
    expect(page).to have_link 'Categorias'
    expect(page).to have_link 'Entrar', href: new_user_session_path
    expect(page).not_to have_link 'Área do Cliente'
    expect(page).to have_css 'nav'
  end
  it 'e vê os produtos listados' do
    category = ProductCategory.create!(name: 'Camisetas')
    FactoryBot.create(:product, name: 'Camiseta Azul', code: 'CMA123456', price: 800, product_category: category)
    FactoryBot.create(:product, name: 'Camiseta Vermelha', code: 'CMV123456', price: 701, product_category: category)

    visit root_path

    expect(page).to have_content 'Produtos'
    expect(page).to have_content 'Camiseta Azul'
    expect(page).to have_content '800 Pontos'
    expect(page).to have_content 'Camiseta Vermelha'
    expect(page).to have_content '701 Pontos'
  end
  it 'e vê menssagem caso não tenha produtos disponíveis' do
    visit root_path

    expect(page).to have_content 'Produtos'
    expect(page).to have_content 'Nenhum produto disponível no momento'
  end
  context 'estando logado' do
    it 'e vê uma barra de navegação' do
      user = FactoryBot.create(:user, name: 'José', email: 'jose@gmail.com', password: 'jose1234')

      login_as(user)
      visit root_path

      expect(page).to have_content 'jose@gmail.com'
      expect(page).to have_link 'Categorias'
      expect(page).to have_link 'Área do Cliente'
      expect(page).to have_button 'Sair'
      expect(page).to have_css 'nav'
      expect(page).not_to have_link 'Entrar'
    end
  end
end