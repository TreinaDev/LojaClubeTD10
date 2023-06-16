require 'rails_helper'

describe 'Administrador desativa uma categoria' do
  it 'e vê mensagem de confirmação' do
    cat = create(:product_category, name: 'Categoria Teste', active: true)
    admin = create(:user, email: 'algumnome@punti.com')

    login_as(admin)
    visit root_path
    within('nav') do
      click_on 'Administração'
      click_on 'Categorias'
    end

    find_button('Desativar', id: cat.id).click

    expect(page).to have_content 'Você tem certeza? Isto irá afetar todos os produtos desta categoria.'
  end

  it 'com sucesso' do
    cat = create(:product_category, name: 'Categoria Teste', active: true)
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path
    find_button('Desativar', id: cat.id).click
    cat.reload

    expect(cat.active).to be false
    expect(page).to have_content 'Categoria desabilitada com sucesso.'
  end

  it 'e reativa uma categoria com sucesso' do
    cat = create(:product_category, name: 'Categoria Teste', active: false)
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path
    find_button('Reativar', id: cat.id).click
    cat.reload

    expect(cat.active).to be true
    expect(page).to have_content 'Categoria reativada com sucesso.'
  end
end
