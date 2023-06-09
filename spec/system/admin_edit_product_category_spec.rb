require 'rails_helper'

describe 'Administrador edita uma categoria' do
  it 'com sucesso' do
    category = create(:product_category)
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path
    click_on 'Editar'
    fill_in 'Nome', with: 'Categoria'
    click_on 'Cadastrar'

    expect(page).to have_content 'A categoria foi editada com sucesso.'
    expect(page).to have_content 'Categoria'
    expect(page).not_to have_content category.name
  end

  it 'e recebe erro pois deixou o nome em branco' do
    category = create(:product_category)
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path
    click_on 'Editar'
    fill_in 'Nome', with: ''
    click_on 'Cadastrar'

    expect(current_path).to eq product_category_path(category.id)
    expect(page).to have_content 'A categoria não pôde ser editada.'
  end
end
