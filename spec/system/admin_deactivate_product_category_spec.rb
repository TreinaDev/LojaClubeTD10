require 'rails_helper'

describe 'Administrador desativa uma categoria' do
  it 'e vê mensagem de confirmação' do
    cat = create(:product_category, name: 'Categoria Teste')
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path

    find_button('Desativar', id: "#{cat.id}_deactivate").click

    expect(page).to have_content 'Você tem certeza? Isto irá afetar todos os produtos desta categoria.'
    expect(page).to have_content 'Categoria: Categoria Teste'
  end

  it 'com sucesso' do
    cat = create(:product_category, name: 'Categoria Teste')
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path

    find_button('Desativar', id: "#{cat.id}_deactivate").click

    within "form##{cat.id}_deactivate_modal" do
      find_button('Desativar').click
    end

    expect(page).to have_button 'Reativar', id: "#{cat.id}_reactivate"
    expect(page).to have_content 'Categoria desabilitada com sucesso.'
  end

  it 'e reativa uma categoria com sucesso' do
    cat = create(:product_category, name: 'Categoria Teste', active: false)
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path

    find_button('Reativar', id: "#{cat.id}_reactivate").click

    within "form##{cat.id}_reactivate_modal" do
      find_button('Reativar').click
    end

    expect(page).to have_button 'Desativar', id: "#{cat.id}_deactivate"
    expect(page).to have_content 'Categoria reativada com sucesso.'
  end
end
