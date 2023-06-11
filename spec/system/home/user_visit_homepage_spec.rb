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
    expect(page).to have_link 'Entrar', href: new_user_session_path
    expect(page).to have_css 'nav'
  end
  it 'e vê os produtos recém adicionados' do
    category = FactoryBot.create(:product_category, name: 'Camisetas')
    FactoryBot.create(:product, name: 'Camiseta Azul', price: 800, product_category: category,
                                description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    FactoryBot.create(:product, name: 'Camiseta Vermelha', price: 701, product_category: category,
                                description: 'Uma camisa vermelha bem grande', code: 'CMV123789')

    visit root_path

    expect(page).to have_content 'Produtos Recentes'
    within('#1.carousel') do
      within('.card#CMA123456') do
        expect(page).to have_content 'Camiseta Azul'
        expect(page).to have_content '800 Pontos'
        expect(page).to have_content 'Uma camisa azul muito bonita'
      end
      within('.card#CMV123789') do
        expect(page).to have_content 'Camiseta Vermelha'
        expect(page).to have_content '701 Pontos'
        expect(page).to have_content 'Uma camisa vermelha bem grande'
      end
    end
  end
  it 'e vê menssagem caso não tenha produtos disponíveis' do
    visit root_path

    expect(page).to have_content 'Produtos'
    expect(page).to have_content 'Nenhum produto disponível no momento'
  end
end
