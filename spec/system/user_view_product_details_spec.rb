require 'rails_helper'

describe 'Usuário acessa detalhes de um produto' do
  it 'a partir da listagem de produtos, como administrador' do
    user = User.create!(name: 'Usuário Administrador', email: 'admin@punti.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')
    category = ProductCategory.create!(name: 'Eletrônico')
    product = Product.create!(name: 'TV42',
                              code: 'ABC123456',
                              description: 'Descrição para o produto',
                              brand: 'LG', price: 2500,
                              product_category: category)
    Product.create!(name: 'TV52', code: 'ABC654321',
                    description: 'Descrição para o produto',
                    brand: 'Samsung', price: 3500,
                    product_category: category)

    login_as(user)
    visit products_path
    click_on 'ABC123456'

    expect(page).to have_content product.name
    expect(page).to have_content product.code
    expect(page).to have_content product.description
    expect(page).to have_content product.brand
    expect(page).to have_content product.product_category.name
  end

  it 'a partir da listagem de produtos, como visitante' do
    category = ProductCategory.create!(name: 'Eletrônico')
    product = Product.create!(name: 'TV42',
                              code: 'ABC123456',
                              description: 'Descrição para o produto',
                              brand: 'LG', price: 2500,
                              product_category: category)

    visit root_path
    click_on 'TV42'

    expect(page).to have_content product.name
    expect(page).to have_content product.code
    expect(page).to have_content product.description
    expect(page).to have_content product.brand
    expect(page).to have_content product.product_category.name
  end

  it 'e não consegue, caso produto esteja desativado' do
    category = ProductCategory.create!(name: 'Eletrônico')
    product = Product.create!(name: 'TV42',
                              code: 'ABC123456',
                              description: 'Descrição para o produto',
                              brand: 'LG', price: 2500,
                              product_category: category,
                              active: false)

    visit product_path(product.id)

    expect(page).to have_content 'Produto indisponível'
    expect(current_path).not_to eq product_path(product.id)
  end
end
