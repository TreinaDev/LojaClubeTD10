require 'rails_helper'

describe 'Administrador cadastra produto' do
  context 'com sucesso' do
    xit 'para uma categoria' do
      Capybara.current_driver = :selenium

      admin = create(:user, email: 'admin@punti.com')
      create(:product_category, name: 'Eletrônico')
      create(:product_category, name: 'Eletrodoméstico')

      login_as(admin)
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
      expect(page).to have_content 'Produto TV 42 - ABC123456'
      expect(page).to have_content 'Descrição'
      expect(page).to have_content 'Descrição para o produto'
      expect(page).to have_content 'Marca'
      expect(page).to have_content 'LG'
      expect(page).to have_content 'Preço'
      expect(page).to have_content 'R$ 2.500,00'
      expect(page).to have_content 'Categoria'
      expect(page).to have_content 'Eletrônico'
    end

    xit 'para uma subcategoria' do
      Capybara.current_driver = :selenium

      admin = create(:user, email: 'admin@punti.com')
      category = create(:product_category, name: 'Eletrônicos')
      create(:product_subcategory, name: 'TV', parent: category)
      create(:product_subcategory, name: 'Smartphones', parent: category)

      login_as(admin)
      visit new_product_path

      attach_file 'Fotos do produto', Rails.root.join('spec/support/imgs/TV.jpg')
      fill_in 'Nome', with: 'TV 42'
      fill_in 'Código', with: 'ABC123456'
      fill_in 'Descrição', with: 'Descrição para o produto'
      fill_in 'Marca', with: 'LG'
      fill_in 'Preço', with: '2500'
      select 'Eletrônicos', from: 'Categoria'
      select 'Smartphones', from: 'Subcategoria'
      click_on 'Cadastrar'

      prod = Product.last
      expect(current_path).to eq product_path(prod.id)
      expect(page).to have_css('img[src*="TV.jpg"]')
      expect(page).to have_content 'Produto TV 42 - ABC123456'
      expect(page).to have_content 'Descrição para o produto'
      expect(page).to have_content 'Marca'
      expect(page).to have_content 'LG'
      expect(page).to have_content 'Preço'
      expect(page).to have_content 'R$ 2.500,00'
      expect(page).to have_content 'Categoria'
      expect(page).to have_content 'Smartphones'
    end
  end

  it 'e não vê categorias desativadas' do
    admin = create(:user, email: 'admin@punti.com')
    category_a = create(:product_category, name: 'Drones')
    category_b = create(:product_category, name: 'Instrumentos Musicais')
    create(:product_category, name: 'Eletrodoméstico')
    create(:product_category, name: 'Informática')
    category_a.update(active: false)
    category_b.update(active: false)

    login_as(admin)
    visit products_path
    click_on 'Novo Produto'

    expect(page).not_to have_select 'Categoria', with_options: ['Drones', 'Instrumentos Musicais']
    expect(page).to have_content 'Eletrodoméstico'
    expect(page).to have_content 'Informática'
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
