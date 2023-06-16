require 'rails_helper'

describe 'Usuário remove produto do carrinho' do
  it 'com sucesso' do
    user = create(:user)
    category1 = create(:product_category, name: 'Camisetas')
    product = create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                    description: 'Uma camisa azul muito bonita', code: 'CMA123456')             
    
    login_as(user)
    visit root_path
    click_on 'Camiseta Azul'
    click_on 'Comprar'
    click_on 'Remover'

    expect(current_path).to eq root_path
  end
end
