require 'rails_helper'

describe 'Usuário pesquisa um produto' do
  it 'a partir de um botão na navbar' do
    visit root_path
    find("#searchProduct").click

    within('#searchModal') do
      expect(page).to have_field 'query'
      expect(page).to have_button 'Buscar'
    end
  end
end
