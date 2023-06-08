require 'rails_helper'

describe 'Administrador acessa detalhes de um produto' do
  it 'a partir da listagem de produtos' do
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
    visit products_path
    click_on 'ABC123456'

    expect(page).to have_content product.name
    expect(page).to have_content product.code
    expect(page).to have_content product.description
    expect(page).to have_content product.brand
    expect(page).to have_content 'R$ 2.500,00'
    expect(page).to have_content product.product_category.name
  end
end
