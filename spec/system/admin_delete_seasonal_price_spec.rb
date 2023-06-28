require 'rails_helper'

describe 'Administrador exclui preço sazonal' do
  it 'com sucesso' do
    admin = create(:user, email: 'admin@punti.com')
    price = create(:seasonal_price)

    login_as admin
    visit seasonal_prices_path

    click_on 'Excluir'

    expect(page).to have_content 'Preço sazonal excluído com sucesso'
    expect(page).not_to have_content price.product.name
    expect(page).not_to have_content price.value
    expect(page).not_to have_content price.start_date
    expect(page).not_to have_content price.end_date
  end
end
