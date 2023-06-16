require 'rails_helper'

describe 'Administrador edita uma subcategoria' do
  it 'com sucesso' do
    FactoryBot.create(:product_subcategory, name: 'Minha subcategoria')

    admin = FactoryBot.create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path

    subcategory_element = find('li:contains("Minha subcategoria") a[href*="/edit"]')
    subcategory_element.click

    fill_in 'Nome', with: 'Subcategoria'
    click_on 'Atualizar subcategoria de produtos'

    expect(page).to have_content 'A subcategoria foi editada com sucesso.'
    expect(page).to have_content 'Subcategoria'
    expect(page).not_to have_content 'Minha subcategoria'
  end

  it 'e recebe erro pois deixou o nome em branco' do
    subcategory = FactoryBot.create(:product_subcategory, name: 'Minha subcategoria')
    admin = FactoryBot.create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path
    subcategory_element = find('li:contains("Minha subcategoria") a[href*="/edit"]')
    subcategory_element.click

    fill_in 'Nome', with: ''
    click_on 'Atualizar subcategoria de produtos'

    expect(current_path).to eq product_subcategory_path(subcategory.id)
    expect(page).to have_content 'A subcategoria não pôde ser editada, revise os campos abaixo:'
  end

  it 'e recebe erro pois usou nome já existente' do
    FactoryBot.create(:product_subcategory, name: 'Subcategoria')

    subcategory = FactoryBot.create(:product_subcategory, name: 'Minha subcategoria')
    admin = FactoryBot.create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path
    subcategory_element = find('li:contains("Minha subcategoria") a[href*="/edit"]')
    subcategory_element.click
    fill_in 'Nome', with: 'Subcategoria'
    click_on 'Atualizar subcategoria de produtos'

    expect(current_path).to eq product_subcategory_path(subcategory.id)
    expect(page).to have_content 'A subcategoria não pôde ser editada, revise os campos abaixo:'
    expect(page).to have_content 'Nome já está em uso'
  end

  it 'como usuário comum tenta acessar, mas não tem acesso' do
    subcategory = FactoryBot.create(:product_subcategory, name: 'Minha subcategoria')
    user = FactoryBot.create(:user, email: 'admin@mail.com')

    login_as(user)
    visit edit_product_subcategory_path(subcategory)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este módulo'
  end

  it 'como usuário visitante tenta acessar, mas não tem acesso' do
    subcategory = FactoryBot.create(:product_subcategory, name: 'Minha subcategoria')

    visit edit_product_subcategory_path(subcategory)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end
end
