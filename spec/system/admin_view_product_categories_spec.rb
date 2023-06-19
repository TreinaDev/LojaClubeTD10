require 'rails_helper'

describe 'Administrador visualiza categorias' do
  it 'com sucesso' do
    category = create(:product_category)
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path

    expect(page).to have_content 'Categorias de produto'
    expect(page).to have_content category.name
    expect(page).not_to have_content 'Você não possui permissão para realizar esta ação'
  end
end
