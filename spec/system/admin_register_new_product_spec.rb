require 'rails_helper'

describe 'Administrador cadastra produto' do
  it 'com sucesso' do
    ProductCategory.create!(name: 'Eletrônico')
    ProductCategory.create!(name: 'Eletrodoméstico')

    visit new_product_path

    within 'form' do
      attach_file 'Fotos do produto', Rails.root.join('spec/support/imgs/TV.jpg')
      fill_in 'Nome', with: 'TV 42'
      fill_in 'Código', with: 'ABC123456'
      fill_in 'Descrição', with: 'Descrição para o produto'
      fill_in 'Marca', with: 'LG'
      fill_in 'Preço', with: '2500'
      select 'Eletrônico', from: 'Categoria'
      click_on 'Cadastrar'
    end

    prod = Product.last
    expect(current_path).to eq product_path(prod.id)
    expect(page).to have_css('img[src*="TV.jpg"]')
    expect(page).to have_content 'Produto ABC123456 - TV 42'
    expect(page).to have_content 'Descrição'
    expect(page).to have_content 'Descrição para o produto'
    expect(page).to have_content 'Marca'
    expect(page).to have_content 'LG'
    expect(page).to have_content 'Preço'
    expect(page).to have_content 'R$ 2.500,00'
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

    expect(page).to have_content 'Não foi possível cadastrar o produto'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Código não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Marca não pode ficar em branco'
  end

  it 'como visitante' do
    Category.create!(name: 'Eletrodoméstico')

    visit root_path
    visit new_product_path

    expect(current_path).to eq root_path
    expect(page).not_to have_field('Nome')
    expect(page).not_to have_field('Categoria', with:'Eletrodoméstico')
    expect(page).to have_content 'Você não possui acesso a este módulo.'
  end

  it 'como usuário comum' do
    user = User.create!(name: 'Maria Sousa', email:'maria@provedor.com', password:'senha1234', cpf: '66610881090')
    Category.create!(name: 'Eletrodoméstico')

    login_as(user)
    visit root_path
    visit new_product_path

    expect(current_path).to eq root_path
    expect(page).not_to have_field('Nome')
    expect(page).not_to have_field('Categoria', with:'Eletrodoméstico')
    expect(page).to have_content 'Você não possui acesso a este módulo.'
  end
end
