require 'rails_helper'

describe 'Visitante navega pela app' do
  it 'e vê tela inicial' do
    visit root_path

    expect(page).to have_content 'Loja do Clube'
    expect(page).to have_link('Loja do Clube', href: root_path)
  end
end
