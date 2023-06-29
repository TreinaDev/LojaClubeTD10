require 'rails_helper'

describe 'Usuário visualiza lista de favoritos' do
  it 'e usuário comum não consegue acessar' do
    visit favorite_tab_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Faça login para acessar'
  end

  it 'e administrador não consegue acessar' do
    admin = create(:user, email: 'matheus@punti.com', password: 'abrir123')
    login_as(admin)

    visit favorite_tab_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Administrador não tem acesso a essa página'
  end

  it 'na área do cliente e existem produtos favoritos disponíveis e indisponíveis' do
    user = User.create!(name: 'matheus', email: 'matheus@mail.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')
    category = create(:product_category)
    product1 = create(:product, name: 'TV', code: 'HJK123456', brand: 'Samsung', product_category: category)
    product2 = create(:product, name: 'Iphone', code: 'ASD123456', brand: 'Apple', product_category: category)
    product3 = create(:product, name: 'Smartwatch', code: 'ASD163426', brand: 'Apple', product_category: category,
                                active: false)
    product4 = create(:product, name: 'Mouse', code: 'ASD143486', brand: 'Logitech', product_category: category,
                                active: false)

    Favorite.create!(user:, product: product1)
    Favorite.create!(user:, product: product2)
    Favorite.create!(user:, product: product3)
    Favorite.create!(user:, product: product4)

    login_as user
    visit customer_areas_path
    click_on 'Meus Favoritos'

    expect(current_path).to eq favorite_tab_path
    within '.available' do
      expect(page).to have_content 'TV, Samsung'
      expect(page).to have_content 'Iphone, Apple'
    end
    within '.unavailable' do
      expect(page).not_to have_content 'TV, Samsung'
      expect(page).not_to have_content 'Iphone, Apple'
      expect(page).to have_content 'Smartwatch, Apple'
      expect(page).to have_content 'Mouse, Logitech'
    end
  end

  it 'na área do cliente e não existem produtos favoritos indisponíveis' do
    user = User.create!(name: 'matheus', email: 'matheus@mail.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')
    category = create(:product_category)
    product1 = create(:product, name: 'TV', code: 'HJK123456', brand: 'Samsung', product_category: category)
    product2 = create(:product, name: 'Iphone', code: 'ASD123456', brand: 'Apple', product_category: category)

    Favorite.create!(user:, product: product1)
    Favorite.create!(user:, product: product2)

    login_as user
    visit customer_areas_path
    click_on 'Meus Favoritos'

    expect(current_path).to eq favorite_tab_path
    within '.available' do
      expect(page).to have_content 'TV, Samsung'
      expect(page).to have_content 'Iphone, Apple'
    end
    expect(page).not_to have_content 'Produtos indisponíveis'
  end

  it 'na área do cliente e não existem produtos favoritos disponíveis' do
    user = User.create!(name: 'matheus', email: 'matheus@mail.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')
    category = create(:product_category)
    product1 = create(:product, name: 'TV', code: 'HJK123456', brand: 'Samsung',
                                product_category: category, active: false)
    product2 = create(:product, name: 'Iphone', code: 'ASD123456', brand: 'Apple',
                                product_category: category, active: false)

    Favorite.create!(user:, product: product1)
    Favorite.create!(user:, product: product2)

    login_as user
    visit customer_areas_path
    click_on 'Meus Favoritos'

    expect(current_path).to eq favorite_tab_path
    within '.unavailable' do
      expect(page).to have_content 'TV, Samsung'
      expect(page).to have_content 'Iphone, Apple'
    end
    expect(page).not_to have_content 'Produtos disponíveis'
  end

  it 'e não tem nenhum favorito selecionado' do
    user = User.create!(name: 'matheus', email: 'matheus@email.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')
    login_as user
    visit customer_areas_path
    click_on 'Meus Favoritos'

    expect(page).to have_content 'Você não selecionou nenhum produto como favorito'
  end
end
