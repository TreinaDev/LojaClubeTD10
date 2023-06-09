require 'rails_helper'

describe 'Admin registra uma nova categoria' do
  it 'com sucesso' do
    visit product_categories_path
    click_on 'Nova Categoria'
    fill_in 'Nome', with: 'Categoria teste'
    click_on 'Criar Categoria de produto'

    expect(page).to have_content 'Categoria teste'
    expect(page).to have_content 'Categoria criada com sucesso.'
  end

  it 'e falha pois o nome ficou em branco' do
    visit product_categories_path
    click_on 'Nova Categoria'
    fill_in 'Nome', with: ''
    click_on 'Criar Categoria de produtos'

    expect(page).to have_content 'Nome não pode ficar em branco'
  end

  it 'e falha pois o nome já existe' do
    ProductCategory.create!(name: 'Categoria Teste')

    visit product_categories_path
    click_on 'Nova Categoria'
    fill_in 'Nome', with: 'Categoria Teste'
    click_on 'Criar Categoria de produtos'

    expect(page).to have_content 'Nome já está em uso'
  end
end
