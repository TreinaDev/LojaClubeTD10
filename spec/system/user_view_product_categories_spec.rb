require 'rails_helper'

describe 'Usuário vê as categorias dos produtos' do
  it 'a partir da barra de navegação' do
    create(:product_category, name: 'Camisetas')
    create(:product_category, name: 'Eletrodomésticos')
    create(:product_category, name: 'Utensílios')

    visit root_path

    expect(page).to have_link 'Camisetas'
    expect(page).to have_link 'Eletrodomésticos'
    expect(page).to have_link 'Utensílios'
  end

  it 'a partir da barra de navegação com subcategoria' do
    category = create(:product_category, name: 'Camisetas')
    create(:product_category, name: 'Eletrodomésticos')
    create(:product_category, name: 'Utensílios')
    ProductSubcategory.create!(parent_id: category.id, name: 'Lisas')

    visit root_path

    expect(page).to have_link 'Camisetas'
    expect(page).to have_link 'Eletrodomésticos'
    expect(page).to have_link 'Utensílios'
    expect(page).to have_link 'Lisas'
  end

  context 'pela página de categorias' do
    it 'e não consegue acessar, pois não tem permissão' do
      user = FactoryBot.create(:user)

      login_as(user)
      visit product_categories_path

      expect(current_path).to eq root_path
      expect(page).to have_content 'Você não possui acesso a este módulo'
    end
  end
end
