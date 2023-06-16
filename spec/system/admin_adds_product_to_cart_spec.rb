require 'rails_helper'

describe 'Administrador adiciona produto no carrinho' do
  it 'e recebe menssagem que não é permitido' do
    user = create(:user, email: 'jose@punti.com')
    category1 = create(:product_category, name: 'Camisetas')
    create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                     description: 'Uma camisa azul muito bonita', code: 'CMA123456')
    login_as(user)
    visit root_path
    click_on 'Camiseta Azul'
    click_on 'Comprar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Administrador não tem acesso a essa página'
  end
end
