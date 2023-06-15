require 'rails_helper'

describe 'Usuário adiciona produto ao carrinho' do
  it 'apenas estando autenticado' do
    category1 = create(:product_category, name: 'Camisetas')
    create(:product, name: 'Camiseta Azul', price: 800, product_category: category1,
                     description: 'Uma camisa azul muito bonita', code: 'CMA123456')

    visit root_path
    click_on 'Camiseta Azul'

    expect(page).not_to have_content 'Quantidade'
    expect(page).not_to button 'Comprar'
    expect(page).not_to have_field 'number_field'
  end
end
