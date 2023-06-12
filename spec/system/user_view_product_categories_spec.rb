require 'rails_helper'

describe 'Usuário vê as categorias dos produtos' do
  it 'a partir da barra de navegação' do
    FactoryBot.create(:product_category, name: 'Camisetas')
    FactoryBot.create(:product_category, name: 'Eletrodomésticos')
    FactoryBot.create(:product_category, name: 'Utensílios')

    visit root_path

    expect(page).to have_link 'Camisetas'
    expect(page).to have_link 'Eletrodomésticos'
    expect(page).to have_link 'Utensílios'
  end
end
