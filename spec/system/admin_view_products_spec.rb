require 'rails_helper'

describe 'Administrador acessa index de produtos' do
  it 'e vê a lista de produtos' do
    user = User.create!(name: 'Usuário Administrador', email: 'admin@punti.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')
    category = ProductCategory.create!(name: 'Eletrônico')
    Product.create!(name: 'TV42',
                    code: 'ABC123456',
                    description: 'Descrição para o produto',
                    brand: 'LG',
                    price: 2500,
                    product_category: category)
    Product.create!(name: 'TV52', code: 'ABC654321',
                    description: 'Descrição para o produto', brand: 'Samsung', price: 3500,
                    product_category: category)

    login_as(user)
    visit root_path
    click_on 'Produtos'

    expect(page).to have_content 'Produtos'
    expect(page).to have_content 'TV42'
    expect(page).to have_content 'ABC123456'
    expect(page).to have_content 'TV52'
    expect(page).to have_content 'ABC654321'
  end

  it 'e não tem produtos cadastrados' do
    user = User.create!(name: 'Usuário Administrador', email: 'admin@punti.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')

    login_as(user)
    visit root_path
    click_on 'Produtos'

    expect(page).to have_content 'Produtos'
    expect(page).not_to have_content 'TV42'
    expect(page).to have_content 'Não existem produtos cadastrados.'
  end

  it 'e visualiza botão para cadastrar novo produto' do
    user = User.create!(name: 'Usuário Administrador', email: 'admin@punti.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')

    login_as(user)
    visit root_path
    click_on 'Produtos'

    expect(page).to have_link 'Novo Produto'
  end

  it 'como visitante' do
    visit products_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end

  it 'como usuário comum' do
    user = User.create!(name: 'Maria Sousa', email: 'maria@provedor.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '66610881090')

    login_as(user)
    visit products_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este módulo'
  end
end
