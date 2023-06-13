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
    category_1 = FactoryBot.create(:product_category, name: 'Camisetas')
    category_2 = FactoryBot.create(:product_category, name: 'Celulares')
    FactoryBot.create(:product, name: 'Camiseta Azul', price: 800, product_category: category_1,
                                description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    FactoryBot.create(:product, name: 'Camiseta Vermelha', price: 701, product_category: category_1,
                                description: 'Uma camisa vermelha bem grande', code: 'CMV123789')
    product = Product.new(name: 'TV42',
                          code: 'ABC123456',
                          description: 'Descrição para o produto',
                          brand: 'LG', price: 2500,
                          product_category: category_2)
    product.product_images.attach(io: Rails.root.join('spec/support/imgs/tv_2.jpg').open, filename: 'tv_2.jpg')
    product.product_images.attach(io: Rails.root.join('spec/support/imgs/tv_22.jpg').open, filename: 'tv_22.jpg')
    product.save!

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
      within('.card#ABC123456') do
        expect(page).to have_content 'TV42'
        expect(page).to have_content '2500'
        expect(page).to have_content 'Descrição para o produto'
        expect(page).to have_content 'Descrição para o produto'
        expect(page).to have_css('img[src*="tv_2.jpg"]')
      end
    end
  end
  it 'e vê imagem padrão caso produto não tenha imagem' do
    category = FactoryBot.create(:product_category, name: 'Celular')
    FactoryBot.create(:product, name: 'Camiseta Azul', price: 800, product_category: category,
                                description: 'Uma camisa azul muito bonita', code: 'CMA123456')

    visit root_path

    expect(page).to have_content 'Produtos Recentes'
    within('#1.carousel') do
      within('.card#CMA123456') do
        expect(page).to have_content 'Camiseta Azul'
        expect(page).to have_content '800 Pontos'
        expect(page).to have_content 'Uma camisa azul muito bonita'
        expect(page).to have_css('img[src*="no_image"]')
      end
    end
  end
  it 'e vê menssagem caso não tenha produtos disponíveis' do
    visit root_path

    expect(page).to have_content 'Produtos'
    expect(page).to have_content 'Nenhum produto disponível no momento'
  end
  it 'é vê um footer com informações' do
    visit root_path

    within('footer') do
      expect(page).to have_content 'Copyright © Loja do Clube, 2023'
    end
  end
end
