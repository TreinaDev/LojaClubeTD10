require 'rails_helper'

describe 'Administrador acessa index de produtos' do
  it 'e vê a lista de produtos' do
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
    visit products_path

    expect(page).to have_content 'Produtos'
    expect(page).to have_content 'TV42'
    expect(page).to have_content 'ABC123456'
    expect(page).to have_content 'TV52'
    expect(page).to have_content 'ABC654321'
  end

  it 'e não tem produtos cadastrados' do
    visit products_path

    expect(page).to have_content 'Produtos'
    expect(page).not_to have_content 'TV42'
    expect(page).to have_content 'Não existem produtos cadastrados.'
  end

  it 'e visualiza botão para cadastrar novo produto' do
    visit products_path

    expect(page).to have_link 'Cadastrar Produto'
  end
end
