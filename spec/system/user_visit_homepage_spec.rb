require 'rails_helper'

describe 'Usuário visita homepage' do
  it 'e vê nome o nome da loja' do
    visit root_path

    expect(page).to have_content 'Loja do Clube'
    expect(page).to have_link 'Loja do Clube', href: root_path
  end
  it 'e vê uma barra de navegação' do
    visit root_path

    expect(page).to have_link 'Categorias de Produtos'
    expect(page).to have_link 'Entrar', href: new_user_session_path
    expect(page).not_to have_link 'Área do Cliente'
    expect(page).to have_css 'nav'
  end
  it 'é vê um footer com informações' do
    visit root_path

    within('footer') do
      expect(page).to have_content 'Copyright © Loja do Clube, 2023'
    end
  end
  it 'e vê os produtos recém adicionados' do
    category1 = create(:product_category, name: 'Camisetas')
    category2 = create(:product_category, name: 'Celulares')
    create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                     description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    create(:product, name: 'Camiseta Vermelha', price: 701, product_category: category1,
                     description: 'Uma camisa vermelha bem grande', code: 'CMV123789')
    product = Product.new(name: 'TV42',
                          code: 'ABC123456',
                          description: 'Descrição para o produto',
                          brand: 'LG', price: 2500,
                          product_category: category2)
    product.product_images.attach(io: Rails.root.join('spec/support/imgs/tv_2.jpg').open, filename: 'tv_2.jpg')
    product.product_images.attach(io: Rails.root.join('spec/support/imgs/tv_22.jpg').open, filename: 'tv_22.jpg')
    product.save!

    visit root_path

    expect(page).to have_content 'Produtos Recentes'
    within('#recent_products.carousel') do
      within('.card#CMA123456') do
        expect(page).to have_content 'Camiseta Azul'
        expect(page).not_to have_content '800 Pontos'
        expect(page).to have_content 'Uma camisa azul muito bonita'
      end
      within('.card#CMV123789') do
        expect(page).to have_content 'Camiseta Vermelha'
        expect(page).not_to have_content '701 Pontos'
        expect(page).to have_content 'Uma camisa vermelha bem grande'
      end
      within('.card#ABC123456') do
        expect(page).to have_content 'TV42'
        expect(page).not_to have_content '2500'
        expect(page).to have_content 'Descrição para o produto'
        expect(page).to have_content 'Descrição para o produto'
        expect(page).to have_css('img[src*="tv_2.jpg"]')
      end
    end
  end
  it 'e vê imagem padrão caso produto não tenha imagem' do
    category = create(:product_category, name: 'Celular')
    create(:product, name: 'Camiseta Azul', price: 800, product_category: category,
                     description: 'Uma camisa azul muito bonita', code: 'CMA123456')

    visit root_path

    expect(page).to have_content 'Produtos Recentes'
    within('#recent_products.carousel') do
      within('.card#CMA123456') do
        expect(page).to have_content 'Camiseta Azul'
        expect(page).to have_content 'Uma camisa azul muito bonita'
        expect(page).to have_css('img[src*="no_image"]')
      end
    end
  end
  it 'e vê mensagem caso não tenha produtos disponíveis' do
    visit root_path

    expect(page).to have_content 'Produtos'
    expect(page).to have_content 'Nenhum produto disponível no momento'
  end
  it 'e vê os produtos, com exceção dos produtos desativados' do
    category = create(:product_category)
    create(:product, name: 'Celular 1', code: 'AFG123456', description: 'Celular 1 AFG',
                     price: 2000, product_category: category)
    create(:product, name: 'Celular 2', code: 'ABC123456', description: 'Celular 2 ABC',
                     price: 2500, product_category: category)
    product = create(:product, name: 'Celular 3', code: 'XYZ456123', description: 'Celular 3 XYZ',
                               product_category: category)
    product.update(active: false)

    visit root_path

    within('#recent_products.carousel') do
      within('.card#AFG123456') do
        expect(page).to have_link 'Celular 1'
        expect(page).to have_content 'Celular 1 AFG'
        expect(page).not_to have_content '2000 Pontos'
      end
      within('.card#ABC123456') do
        expect(page).to have_link 'Celular 2'
        expect(page).to have_content 'Celular 2 ABC'
        expect(page).not_to have_content '2500 Pontos'
      end
    end
    expect(page).not_to have_css '.card#XYZ456123'
    expect(page).not_to have_link 'Celular 3'
    expect(page).not_to have_content 'Celular 3 XYZ'
  end
  context 'estando logado' do
    it 'e vê uma barra de navegação exclusiva' do
      user = create(:user, name: 'José', email: 'jose@gmail.com', password: 'jose1234')

      login_as(user)
      visit root_path

      expect(page).to have_content 'jose@gmail.com'
      expect(page).to have_link 'Categorias de Produtos'
      expect(page).to have_link 'Área do Cliente'
      expect(page).to have_button 'Sair'
      expect(page).to have_css 'nav'
      expect(page).not_to have_link 'Entrar'
      expect(page).not_to have_link 'Administração'
      expect(page).not_to have_link 'Categorias', href: product_categories_path
      expect(page).not_to have_content 'jose@gmail.com (ADMIN)'
    end
    it 'e vê os preços dos produtos em pontos, de acordo com a taxa de conversão' do
      user = create(:user, email: 'user@email.com')
      category = create(:product_category, name: 'Eletrodoméstico')
      create(:product, name: 'Geladeira branca', code: 'GLD678456', description: 'Geladeira bonita',
                       price: 200, product_category: category)
      card_json_data = Rails.root.join('spec/support/json/card_data_active.json').read
      card_fake_response = double('faraday_response', status: 200, body: card_json_data)
      allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(card_fake_response)
      company_json_data = Rails.root.join('spec/support/json/cpf_active_company.json').read
      company_fake_response = double('faraday_response', status: 200, body: company_json_data)
      allow(Faraday).to receive(:get).with("http://localhost:3000/api/v1/employee_profiles?cpf=#{user.cpf}").and_return(company_fake_response)

      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail',	with: 'user@email.com'
      fill_in 'Senha',	with: 'password'
      within 'form' do
        click_on 'Entrar'
      end

      within('#recent_products.carousel') do
        within('.card#GLD678456') do
          expect(page).to have_content 'Geladeira branca'
          expect(page).to have_content 'Geladeira bonita'
          expect(page).to have_content '4.000 Pontos'
        end
      end
    end
    it 'e vê os produtos, com exceção dos produtos desativados' do
      user = create(:user)
      session_user = { status_user: 'unblocked' }
      allow_any_instance_of(ApplicationController).to receive(:session).and_return(session_user)
      category = create(:product_category)
      create(:product, name: 'Celular 1', code: 'AFG123456', description: 'Celular 1 AFG',
                       price: 100, product_category: category)
      create(:product, name: 'Celular 2', code: 'ABC123456', description: 'Celular 2 ABC',
                       price: 100, product_category: category)
      product = create(:product, name: 'Celular 3', code: 'XYZ456123', description: 'Celular 3 XYZ',
                                 product_category: category)
      product.update(active: false)
      create(:card_info, user:)

      login_as(user)
      visit root_path

      within('#recent_products.carousel') do
        within('.card#AFG123456') do
          expect(page).to have_link 'Celular 1'
          expect(page).to have_content 'Celular 1 AFG'
          expect(page).to have_content '2.000 Pontos'
        end
        within('.card#ABC123456') do
          expect(page).to have_link 'Celular 2'
          expect(page).to have_content 'Celular 2 ABC'
          expect(page).to have_content '2.000 Pontos'
        end
      end
      expect(page).not_to have_css '.card#XYZ456123'
      expect(page).not_to have_link 'Celular 3'
      expect(page).not_to have_content 'Celular 3 XYZ'
    end
  end
end
