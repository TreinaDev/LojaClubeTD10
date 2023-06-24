require 'rails_helper'

describe 'Administrador visita homepage' do
  it 'e vê barra de navegação exclusiva' do
    user_admin = create(:user, name: 'Mario', email: 'mario@punti.com')

    login_as(user_admin)
    visit root_path

    expect(page).to have_css 'nav'
    expect(page).to have_content 'mario@punti.com (ADMIN)'
    expect(page).to have_link 'Administração'
    expect(page).to have_link 'Categorias', href: product_categories_path
    expect(page).to have_link 'Produtos', href: products_path
    expect(page).not_to have_link 'Área do Cliente'
  end
  it 'e vê os produtos, com exceção dos produtos desativados' do
    user = create(:user, email: 'mario@punti.com')
    category = create(:product_category)
    create(:product, name: 'Celular 1', code: 'AFG123456', description: 'Celular 1 AFG',
                     price: 2000, product_category: category)
    create(:product, name: 'Celular 2', code: 'ABC123456', description: 'Celular 2 ABC',
                     price: 2500, product_category: category)
    product = create(:product, name: 'Celular 3', code: 'XYZ456123', description: 'Celular 3 XYZ',
                               product_category: category)
    product.update(active: false)

    login_as(user)
    visit root_path

    within('#recent_products.carousel') do
      within('.card#AFG123456') do
        expect(page).to have_link 'Celular 1'
        expect(page).to have_content 'Celular 1 AFG'
        expect(page).to have_content 'R$ 2.000,00'
      end
      within('.card#ABC123456') do
        expect(page).to have_link 'Celular 2'
        expect(page).to have_content 'Celular 2 ABC'
        expect(page).to have_content 'R$ 2.500,00'
      end
    end
    expect(page).not_to have_css '.card#XYZ456123'
    expect(page).not_to have_link 'Celular 3'
    expect(page).not_to have_content 'Celular 3 XYZ'
  end
end
