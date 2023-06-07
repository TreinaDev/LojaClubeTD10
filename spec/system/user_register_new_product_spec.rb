require 'rails_helper'

describe 'Usuário cadastro produto' do
  it 'com sucesso' do
    ProductCategory.create!(name: 'Eletrônico')
    ProductCategory.create!(name: 'Eletrodoméstico')

    visit new_product_path

    within 'form' do
      fill_in 'Nome', with: 'TV 42'
      fill_in 'Código', with: 'abc123'
      fill_in 'Descrição', with: 'nova'
      fill_in 'Marca', with: 'LG'
      fill_in 'Preço', with: '2500'
      select 'Eletrônico', from: 'Categoria'
      click_on 'Cadastrar'
    end

    expect(current_path).to eq product_path(Product.last)
    expect(page).to have_content 'Produto abc123 - TV 42'
    expect(page).to have_content 'Descrição'
    expect(page).to have_content 'nova'
    expect(page).to have_content 'Marca'
    expect(page).to have_content 'LG'
    expect(page).to have_content 'Preço'
    expect(page).to have_content '2500'
    expect(page).to have_content 'Categoria'
    expect(page).to have_content 'Eletrônico'
  end

  it 'com dados incompletos' do
    ProductCategory.create!(name: 'Eletrônico')
    ProductCategory.create!(name: 'Eletrodoméstico')

    visit new_product_path

    within 'form' do
      fill_in 'Nome', with: ''
      fill_in 'Código', with: ''
      fill_in 'Descrição', with: ''
      fill_in 'Marca', with: ''
      fill_in 'Preço', with: '2500'
      select 'Eletrônico', from: 'Categoria'
      click_on 'Cadastrar'
    end

    expect(page).to have_content 'Não foi possível cadastrar o produto.'
  end
end
