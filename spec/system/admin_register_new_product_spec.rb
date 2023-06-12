require 'rails_helper'

describe 'Administrador cadastra produto' do
  it 'com sucesso' do
    user = User.create!(name: 'Usuário Administrador', email: 'admin@punti.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')
    ProductCategory.create!(name: 'Eletrônico')
    ProductCategory.create!(name: 'Eletrodoméstico')

    login_as(user)
    visit new_product_path

    attach_file 'Fotos do produto', Rails.root.join('spec/support/imgs/TV.jpg')
    fill_in 'Nome', with: 'TV 42'
    fill_in 'Código', with: 'ABC123456'
    fill_in 'Descrição', with: 'Descrição para o produto'
    fill_in 'Marca', with: 'LG'
    fill_in 'Preço', with: '2500'
    select 'Eletrônico', from: 'Categoria'
    click_on 'Cadastrar'

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
    user = User.create!(name: 'Usuário Administrador', email: 'admin@punti.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')
    ProductCategory.create!(name: 'Eletrônico')
    ProductCategory.create!(name: 'Eletrodoméstico')

    login_as(user)
    visit new_product_path

    fill_in 'Nome', with: ''
    fill_in 'Código', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Marca', with: ''
    fill_in 'Preço', with: '2500'
    select 'Eletrônico', from: 'Categoria'
    click_on 'Cadastrar'

    expect(page).to have_content 'Não foi possível cadastrar o produto'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Código não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Marca não pode ficar em branco'
  end

  it 'como visitante' do
    visit root_path
    visit new_product_path

    expect(current_path).to eq new_user_session_path
    expect(page).not_to have_field('Nome')
    expect(page).not_to have_field('Categoria', with: 'Eletrodoméstico')
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end

  it 'como usuário comum' do
    user = User.create!(name: 'Maria Sousa', email: 'maria@provedor.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '66610881090')

    login_as(user)
    visit root_path
    visit new_product_path

    expect(current_path).to eq root_path
    expect(page).not_to have_field('Nome')
    expect(page).not_to have_field('Categoria', with: 'Eletrodoméstico')
    expect(page).to have_content 'Você não possui acesso a este módulo'
  end
end
