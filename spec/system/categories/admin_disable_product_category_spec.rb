require 'rails_helper'

describe 'Administrador desativa uma categoria' do
  it 'e vê mensagem de confirmação' do
    # Arrange
    FactoryBot.create(:product_category, name: 'Categoria Teste')
    # Act
    visit product_categories_path
    click_on 'Editar'
    click_on 'Desativar Categoria'

    # expect(page).to have_content 'Você tem certeza? Todos os produtos vinculados a essa categoria serão desativados.'
  end

  it 'com sucesso' do
    # Arrange
    category = FactoryBot.create(:product_category, name: 'Categoria Teste')
    # Act
    visit product_categories_path
    click_on 'Editar'
    click_on 'Desativar Categoria'
    category.reload
    # Assert
    expect(category.active).to be false
    expect(current_path).to eq product_categories_path
  end

  it 'e reativa com sucesso' do
    # Arrange
    category = FactoryBot.create(:product_category, name: 'Categoria Teste')
    # Act
    visit product_categories_path
    click_on 'Editar'
    click_on 'Desativar Categoria'
    click_on 'Editar'
    click_on 'Reativar Categoria'
    category.reload
    # Assert
    expect(category.active).to be true
    expect(current_path).to eq product_categories_path
  end
end
