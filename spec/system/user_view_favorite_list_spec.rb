require 'rails_helper'

describe 'Usuário visualiza lista de favoritos' do 
  it 'na área do cliente' do 
    user = User.create!(name: 'matheus', email: 'matheus@mail.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')
    category = FactoryBot.create(:product_category)
    product1 = FactoryBot.create(:product, name: 'TV', code: 'HJK123456', product_category: category)
    product2 = FactoryBot.create(:product, name: 'Iphone', code: 'ASD123456', product_category: category)

    favorite1 = Favorite.create!(user: user, product: product1)
    favorite2 = Favorite.create!(user: user, product: product2) 

    login_as user
    visit customer_areas_path
    click_on 'Produtos Favoritos'

    expect(current_path).to eq favorite_tab_path
    expect(page).to have_content 'HJK123456 - TV'
    expect(page).to have_content 'ASD123456 - Iphone'
  end

  it 'e não tem nenhum favorito selecionado' do
    user = User.create!(name: 'matheus', email: 'matheus@mail.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')
                        login_as user
    visit customer_areas_path
    click_on 'Produtos Favoritos'

    expect(page).to have_content 'Você não selecionou nenhum produto como favorito'
  end
end
