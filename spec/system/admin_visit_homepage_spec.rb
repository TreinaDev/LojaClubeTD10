require 'rails_helper'

describe 'Administrador visita homepage' do
  it 'e vê barra de navegação exclusiva' do
    user_admin = FactoryBot.create(:user, name: 'Mario', email: 'mario@punti.com')

    login_as(user_admin)
    visit root_path

    expect(page).to have_css 'nav'
    expect(page).to have_content 'mario@punti.com (ADMIN)'
    expect(page).to have_link 'Administração'
    expect(page).to have_link 'Categorias'
    expect(page).to have_link 'Produtos'
    expect(page).not_to have_link 'Área do Cliente'
  end
end
