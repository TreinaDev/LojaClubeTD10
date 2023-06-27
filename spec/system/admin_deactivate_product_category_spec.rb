require 'rails_helper'

describe 'Administrador desativa uma categoria' do
  it 'e vê mensagem de confirmação' do
    cat = create(:product_category, name: 'Categoria Teste')
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit product_categories_path

    find_button('Desativar', id: "#{cat.id}_deactivate").click

    expect(page).to have_content 'Atenção! Desabilitar a categoria não ocultará os seus produtos.'
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

  it 'e categoria deixa de aparecer nas campanhas às quais pertencia' do
    admin = create(:user, email: 'admin@punti.com')
    campaign = create(:promotional_campaign, name: 'Dia das crianças')
    cat_a = create(:product_category, name: 'Celulares', active: true)
    cat_b = create(:product_category, name: 'Eletrônicos', active: true)
    create(:product_category, name: 'Vestuário', active: true)
    create(:campaign_category, product_category: cat_a, promotional_campaign: campaign, discount: 11)
    create(:campaign_category, product_category: cat_b, promotional_campaign: campaign, discount: 23)
    cat_a.update(active: false)
    cat_a.reload

    login_as(admin)
    visit promotional_campaign_path(campaign)

    expect(page).to have_select 'Categoria', with_options: %w[Selecione Vestuário]
    expect(page).to have_content 'Eletrônicos - 23% de desconto'
    expect(page).not_to have_content 'Celulares - 11% de desconto'
  end
end
