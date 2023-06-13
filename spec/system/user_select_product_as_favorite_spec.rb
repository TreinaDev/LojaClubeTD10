require 'rails_helper'

describe 'Usuário seleciona favorito' do 
  it 'a partir da tela de produto' do 
    user = User.create!(name: 'matheus', email: 'matheus@mail.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')
    category = FactoryBot.create(:product_category)
    product1 = FactoryBot.create(:product, name: 'TV', code: 'HJK123456', product_category: category)

    login_as user
    visit product_path(product1)
    click_on 'Marcar como favorito'

    expect(page).to have_content 'TV está na sua lista de produtos favoritos'
    expect(page).not_to have_button 'Marcar como favorito'
    expect(page).to have_button 'Remover dos favoritos'
  end
end