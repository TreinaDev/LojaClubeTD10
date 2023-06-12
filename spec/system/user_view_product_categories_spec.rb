require 'rails_helper'

describe 'Usuário visualiza categorias' do
  it 'com sucesso' do
    category = FactoryBot.create(:product_category)

    visit product_categories_path

    expect(page).to have_content 'Categorias de produto'
    expect(page).to have_content category.name
  end
end
