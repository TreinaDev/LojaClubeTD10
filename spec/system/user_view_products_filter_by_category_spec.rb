require 'rails_helper'

describe 'Usuário vê os produtos da categoria escolhida no menu Categorias de Produtos' do
  context 'como visitante' do
    it 'e vê produtos ativos e não vê produtos desativados, nem vê o valor nem os pontos convertidos de cada produto' do
      category = create(:product_category, name: 'Celular')
      category_a = create(:product_category, name: 'Vestuário')
      create(:product, name: 'Camiseta Azul', code: 'CMS123456', description: 'Uma camisa azul muito bonita',
                       price: 8, product_category: category_a)
      create(:product, name: 'Celular 1', code: 'AFG123456', description: 'Celular 1 AFG',
                       price: 100, product_category: category)
      create(:product, name: 'Celular 2', code: 'ABC123456', description: 'Celular 2 ABC',
                       price: 100, product_category: category)
      product = create(:product, name: 'Celular 3', code: 'XYZ456123', description: 'Celular 3 XYZ',
                                 product_category: category)
      product.update(active: false)

      visit root_path
      click_on 'Categorias de Produtos'
      click_on 'Celular'

      within('#recent_products.carousel') do
        within('.card#AFG123456') do
          expect(page).to have_link 'Celular 1'
          expect(page).to have_content 'Celular 1 AFG'
          expect(page).not_to have_content '2.000 Pontos'
        end
        within('.card#ABC123456') do
          expect(page).to have_link 'Celular 2'
          expect(page).to have_content 'Celular 2 ABC'
          expect(page).not_to have_content '2.000 Pontos'
        end
      end
      expect(page).to have_css '.card#CMS123456'
      expect(page).to have_link 'Camiseta Azul'
      expect(page).to have_content 'Uma camisa azul muito bonita'
      expect(page).not_to have_css '.card#XYZ456123'
      expect(page).not_to have_link 'Celular 3'
      expect(page).not_to have_content 'Celular 3 XYZ'
    end
  end
  context 'como usuário logado' do
    it 'e vê produtos ativos e não vê produtos desativados, e vê o valor de cada produto convertido em pontos' do
      user = create(:user)
      create(:card_info, user:)
      category = create(:product_category, name: 'Celular')
      category_a = create(:product_category, name: 'Vestuário')
      create(:product, name: 'Camiseta Azul', code: 'CMS123456', description: 'Uma camisa azul muito bonita',
                       price: 8, product_category: category_a)
      create(:product, name: 'Celular 1', code: 'AFG123456', description: 'Celular 1 AFG',
                       price: 100, product_category: category)
      create(:product, name: 'Celular 2', code: 'ABC123456', description: 'Celular 2 ABC',
                       price: 100, product_category: category)
      product = create(:product, name: 'Celular 3', code: 'XYZ456123', description: 'Celular 3 XYZ',
                                 price: 100, product_category: category)
      product.update(active: false)

      login_as(user)
      visit root_path
      click_on 'Categorias de Produtos'
      click_on 'Celular'

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
      expect(page).to have_css '.card#CMS123456'
      expect(page).to have_link 'Camiseta Azul'
      expect(page).to have_content 'Uma camisa azul muito bonita'
      expect(page).not_to have_css '.card#XYZ456123'
      expect(page).not_to have_link 'Celular 3'
      expect(page).not_to have_content 'Celular 3 XYZ'
    end
  end
  context 'como administrador' do
    it 'e vê produtos ativos e não vê produtos desativados, e vê o valor em Real(R$) de cada produto' do
      admin = create(:user, email: 'admin@punti.com')
      category = create(:product_category, name: 'Celular')
      category_a = create(:product_category, name: 'Vestuário')
      create(:product, name: 'Camiseta Azul', code: 'CMS123456', description: 'Uma camisa azul muito bonita',
                       price: 8, product_category: category_a)
      create(:product, name: 'Celular 1', code: 'AFG123456', description: 'Celular 1 AFG',
                       price: 100, product_category: category)
      create(:product, name: 'Celular 2', code: 'ABC123456', description: 'Celular 2 ABC',
                       price: 100, product_category: category)
      product = create(:product, name: 'Celular 3', code: 'XYZ456123', description: 'Celular 3 XYZ',
                                 price: 100, product_category: category)
      product.update(active: false)

      login_as(admin)
      visit root_path
      click_on 'Categorias de Produtos'
      click_on 'Celular'

      within('#recent_products.carousel') do
        within('.card#AFG123456') do
          expect(page).to have_link 'Celular 1'
          expect(page).to have_content 'Celular 1 AFG'
          expect(page).to have_content 'R$ 100,00'
        end
        within('.card#ABC123456') do
          expect(page).to have_link 'Celular 2'
          expect(page).to have_content 'Celular 2 ABC'
          expect(page).to have_content 'R$ 100,00'
        end
      end
      expect(page).to have_css '.card#CMS123456'
      expect(page).to have_link 'Camiseta Azul'
      expect(page).to have_content 'Uma camisa azul muito bonita'
      expect(page).not_to have_css '.card#XYZ456123'
      expect(page).not_to have_link 'Celular 3'
      expect(page).not_to have_content 'Celular 3 XYZ'
    end
  end
end
