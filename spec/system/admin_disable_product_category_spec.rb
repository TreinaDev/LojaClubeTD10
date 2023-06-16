require 'rails_helper'

describe 'Administrador desativa uma categoria' do
  it 'e vê mensagem de confirmação' do
    FactoryBot.create(:product_category, name: 'Categoria Teste')
    admin = FactoryBot.create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path
    click_on 'Editar'
    click_on 'Desativar'

    expect(page).to have_content 'Você tem certeza? Todos os produtos vinculados a essa categoria serão desativados.'
  end

  it 'com sucesso' do
    category = FactoryBot.create(:product_category, name: 'Categoria Teste')
    admin = FactoryBot.create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path
    click_on 'Editar'
    click_on 'Desativar'
    click_on 'Desativar categoria'
    category.reload

    expect(category.active).to be false
    expect(page).to have_content 'Categoria desabilitada com sucesso.'
  end

  it 'e reativa uma categoria com sucesso' do
    category = FactoryBot.create(:product_category, name: 'Categoria Teste', active: false)
    admin = FactoryBot.create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path
    click_on 'Editar'
    click_on 'Reativar'
    click_on 'Reativar categoria'
    category.reload

    expect(category.active).to be true
    expect(page).to have_content 'Categoria reativada com sucesso.'
  end
end
