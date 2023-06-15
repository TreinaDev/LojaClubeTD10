require 'rails_helper'

describe 'Usuário remove um produto de sua lista de favoritos' do
  it 'a partir da pégina do produto' do
    user = User.create!(name: 'matheus', email: 'matheus@mail.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')
    category = FactoryBot.create(:product_category)
    product = FactoryBot.create(:product, name: 'TV', code: 'HJK123456', product_category: category)

    Favorite.create!(user:, product: product)

    login_as user
    visit product_path(product)
    click_on 'Remover dos favoritos'

    expect(page).to have_content 'Produto excluído da sua lista de favoritos'
    expect(page).to have_button 'Marcar como favorito'
    expect(page).not_to have_button 'Remover dos favoritos'
  end

  it 'a partir da área do cliente' do
    user = User.create!(name: 'matheus', email: 'matheus@mail.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')
    category = FactoryBot.create(:product_category)
    product1 = FactoryBot.create(:product, name: 'TV', code: 'HJK123456', product_category: category)
    product2 = FactoryBot.create(:product, name: 'Iphone', code: 'ASD123456', product_category: category)

    Favorite.create!(user:, product: product1)
    favorite = Favorite.create!(user:, product: product2)

    login_as user
    visit customer_areas_path
    click_on 'Produtos Favoritos'
    find_button('Excluir', id: favorite.id).click

    expect(page).to have_content 'Produto excluído da sua lista de favoritos'
    expect(page).to have_content 'HJK123456 - TV'
    expect(page).not_to have_content 'ASD123456 - Iphone'
  end
end
