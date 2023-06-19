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

  it 'na área do cliente' do
    user = User.create!(name: 'matheus', email: 'matheus@mail.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')
    category = create(:product_category)
    product1 = create(:product, name: 'TV', code: 'HJK123456', brand: 'Samsung', product_category: category)
    product2 = create(:product, name: 'Iphone', code: 'ASD123456', brand: 'Apple', product_category: category)

    Favorite.create!(user:, product: product1)
    Favorite.create!(user:, product: product2)

    login_as user
    visit customer_areas_path
    click_on 'Produtos Favoritos'

    expect(current_path).to eq favorite_tab_path
    expect(page).to have_content 'TV, Samsung'
    expect(page).to have_content 'Iphone, Apple'
  end

  it 'e não tem nenhum favorito selecionado' do
    user = User.create!(name: 'matheus', email: 'matheus@email.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')
    login_as user
    visit customer_areas_path
    click_on 'Produtos Favoritos'

    expect(page).to have_content 'Você não selecionou nenhum produto como favorito'
  end
end