require 'rails_helper'

describe 'Usuário visualiza categorias' do
  it 'com sucesso' do
    FactoryBot.create(:product_category, name: 'Categoria Teste')

    visit product_categories_path

    expect(page).to have_content 'Categorias de produto'
    expect(page).to have_content 'Categoria Teste'
  end
end
