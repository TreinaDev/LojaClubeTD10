require 'rails_helper'

describe 'Administrador desativa uma categoria' do
  it 'e vê mensagem de confirmação' do
    cat = create(:product_category, name: 'Categoria Teste')
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path

    find_button('Desativar', id: "#{cat.id}_deactivate").click

    expect(page).to have_content 'Atenção! Desabilitar a categoria não ocultará os seus produtos.
                                  E a categoria será removida de todas as campanhas a que pertence.'
    expect(page).to have_content 'Categoria: Categoria Teste'
  end

  it 'com sucesso' do
    cat = create(:product_category, name: 'Categoria Teste')
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path
    find_button('Desativar', id: "#{cat.id}_deactivate").click
    find_button('Desativar', id: "#{cat.id}_deactivate_modal").click

    cat.reload

    expect(cat.active).to be false
    expect(page).to have_content 'Categoria desabilitada com sucesso.'
  end

  it 'e reativa uma categoria com sucesso' do
    cat = create(:product_category, name: 'Categoria Teste', active: false)
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path
    find_button('Reativar', id: "#{cat.id}_reactivate").click
    find_button('Reativar', id: "#{cat.id}_reactivate_modal").click

    cat.reload

    expect(cat.active).to be true
    expect(page).to have_content 'Categoria reativada com sucesso.'
  end
end
