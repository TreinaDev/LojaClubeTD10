require 'rails_helper'

describe 'Usuário tenta registrar uma categoria de produtos' do
  it 'e não consegue acessar, pois não tem permissão' do
    user = FactoryBot.create(:user)

    login_as(user)
    visit product_categories_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui permissão para realizar esta ação.'
  end
end
