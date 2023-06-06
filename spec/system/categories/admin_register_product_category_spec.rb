require 'rails_helper'

describe 'Admin registra uma nova categoria' do
  it 'com sucesso' do
    admin = User.create!(email: "admin@punti.com", password: '123123')

    visit product_categories_path
    click_on 'Nova Categoria'
    fill_in 'Nome', with: 'Alguma categoria'
    click_on 'Salvar'

    expect(page).to have_content 'Alguma categoria'
    expect(page).to have_content 'Categoria criada com sucesso.'
  end 
end