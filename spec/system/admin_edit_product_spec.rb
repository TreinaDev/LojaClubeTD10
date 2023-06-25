require 'rails_helper'

describe 'Administrador edita um produto' do
  it 'a partir da listagem de produtos' do
    user = User.create!(name: 'Usuário Administrador', email: 'admin@punti.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')
    category = ProductCategory.create!(name: 'Eletrônico')
    Product.create!(name: 'TV42',
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
    find_link('Editar', id: 'product_1').click

    expect(current_path).to eq edit_product_path(1)
    expect(page).to have_field('Fotos do produto')
    expect(page).to have_field('Nome')
    expect(page).to have_field('Código')
    expect(page).to have_field('Descrição')
    expect(page).to have_field('Marca')
    expect(page).to have_field('Preço')
  end

  it 'e não vê categorias desativadas' do
    admin = create(:user, email: 'admin@punti.com')
    category_a = create(:product_category, name: 'Drones')
    category_b = create(:product_category, name: 'Instrumentos Musicais')
    category_c = create(:product_category, name: 'Eletrodoméstico')
    create(:product_category, name: 'Informática')
    category_a.update(active: false)
    category_b.update(active: false)

    create(:product, product_category: category_c)
    create(:product, code: 'ABC654321', product_category: category_c)

    login_as(admin)
    visit products_path
    find_link('Editar', id: 'product_1').click

    expect(current_path).to eq edit_product_path(1)
    expect(page).to have_field('Fotos do produto')
    expect(page).to have_field('Nome')
    expect(page).to have_field('Código')
    expect(page).to have_field('Descrição')
    expect(page).to have_field('Marca')
    expect(page).to have_field('Preço')
    expect(page).not_to have_select 'Categoria', with_options: ['Drones', 'Instrumentos Musicais']
    expect(page).to have_select 'Categoria', with_options: %w[Eletrodoméstico Informática]
  end

  it 'com sucesso' do
    user = User.create!(name: 'Usuário Administrador', email: 'admin@punti.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')
    category = ProductCategory.create!(name: 'Eletrônico')
    product = Product.new(name: 'TV42',
                          code: 'ABC123456',
                          description: 'Descrição para o produto',
                          brand: 'LG', price: 2500,
                          product_category: category)
    product.product_images.attach(io: Rails.root.join('spec/support/imgs/tv_2.jpg').open, filename: 'tv_2.jpg')
    product.product_images.attach(io: Rails.root.join('spec/support/imgs/tv_22.jpg').open, filename: 'tv_22.jpg')
    product.save!

    login_as(user)
    visit products_path
    find_link('Editar', id: 'product_1').click

    fill_in 'Nome', with: 'TV27'
    fill_in 'Descrição', with: 'Nova descrição para o produto'
    fill_in 'Marca', with: 'AOC'
    fill_in 'Preço', with: '1500'
    click_on 'Cadastrar'

    expect(page).to have_content 'Produto alterado com sucesso'
    expect(page).to have_content 'Produto TV27 - ABC123456'
    expect(page).to have_content 'Descrição Nova descrição para o produto'
    expect(page).to have_content 'Marca AOC'
    expect(page).to have_content 'Preço'
    expect(page).to have_content 'R$ 1.500,00'
    expect(page).to have_content 'Categoria Eletrônico'
  end

  it 'com dados incompletos' do
    user = User.create!(name: 'Usuário Administrador', email: 'admin@punti.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')
    category = ProductCategory.create!(name: 'Eletrônico')
    product = Product.new(name: 'TV42',
                          code: 'ABC123456',
                          description: 'Descrição para o produto',
                          brand: 'LG', price: 2500,
                          product_category: category)
    product.product_images.attach(io: Rails.root.join('spec/support/imgs/tv_2.jpg').open, filename: 'tv_2.jpg')
    product.product_images.attach(io: Rails.root.join('spec/support/imgs/tv_22.jpg').open, filename: 'tv_22.jpg')
    product.save!

    login_as(user)
    visit products_path
    find_link('Editar', id: 'product_1').click

    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: 'Nova descrição para o produto'
    fill_in 'Marca', with: 'AOC'
    fill_in 'Preço', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content 'Não foi possível alterar o produto'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Preço não é um número'
  end

  it 'como visitante' do
    category = ProductCategory.create!(name: 'Eletrônico')
    product = Product.create!(name: 'TV42',
                              code: 'ABC123456',
                              description: 'Descrição para o produto',
                              brand: 'LG', price: 2500,
                              product_category: category)

    visit root_path
    visit edit_product_path(product.id)

    expect(current_path).to eq new_user_session_path
    expect(page).not_to have_field('Nome')
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end

  it 'como usuário comum' do
    user = User.create!(name: 'Maria Sousa', email: 'maria@provedor.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '66610881090')
    category = ProductCategory.create!(name: 'Eletrônico')
    product = Product.create!(name: 'TV42',
                              code: 'ABC123456',
                              description: 'Descrição para o produto',
                              brand: 'LG', price: 2500,
                              product_category: category)
    login_as(user)
    visit edit_product_path(product.id)

    expect(current_path).to eq root_path
    expect(page).not_to have_field('Nome')
    expect(page).to have_content 'Você não possui acesso a este módulo'
  end
end
