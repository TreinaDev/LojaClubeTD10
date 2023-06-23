require 'rails_helper'

describe 'Admin filtra produtos por status' do
  it 'e clica em Ver Todos' do
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
    click_on 'Ver Todos'

    expect(page).to have_content 'Celular Motorola'
    expect(page).to have_content 'TV LG'
    expect(page).to have_content 'TV Samsung'
    expect(page).not_to have_button 'Desativar todos'
    expect(page).not_to have_button 'Reativar todos'
  end
end
