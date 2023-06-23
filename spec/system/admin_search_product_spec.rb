require 'rails_helper'

describe 'Admin busca produtos na página de produtos' do
  it 'com sucesso' do
    admin = create(:user, email: 'admin@punti.com')
    create(:product, name: 'TV LG')
    create(:product, code: 'ASD456789', name: 'TV Samsung')
    create(:product, code: 'CVB987675', name: 'Celular Motorola')

    login_as(admin)
    visit products_path
    fill_in 'query_products', with: 'TV'
    within('.input-group') do
      click_on 'Filtrar'
    end

    expect(page).not_to have_content 'Celular Motorola'
    expect(page).to have_content 'TV LG'
    expect(page).to have_content 'TV Samsung'
    expect(page).to have_button 'Desativar todos'
    expect(page).to have_button 'Reativar todos'
  end

  it 'e não há produtos correspondentes à busca' do
    admin = create(:user, email: 'admin@punti.com')
    create(:product, name: 'TV LG')
    create(:product, code: 'ASD456789', name: 'TV Samsung')
    create(:product, code: 'CVB987675', name: 'Celular Motorola')

    login_as(admin)
    visit products_path
    fill_in 'query_products', with: 'Monitor'
    within('.input-group') do
      click_on 'Filtrar'
    end

    expect(page).to have_content 'Não há produtos que correspondam à busca'
    expect(page).not_to have_content 'Celular Motorola'
    expect(page).not_to have_content 'TV LG'
    expect(page).not_to have_content 'TV Samsung'
  end
end
