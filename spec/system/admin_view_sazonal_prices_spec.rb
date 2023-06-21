require 'rails_helper'

describe 'Administrador acessa listagem de preços sazonais' do
  it 'com sucesso' do
    admin = create(:user, email: 'admin@punti.com')
    price = create(:seasonal_price)

    login_as admin
    visit root_path
    click_on 'Preços sazonais'

    expect(current_path).to eq seasonal_prices_path
    expect(page).to have_content ActiveSupport::NumberHelper.number_to_currency(price.value)
    expect(page).to have_content I18n.l(price.start_date)
    expect(page).to have_content I18n.l(price.end_date)
    expect(page).to have_content price.product.name
  end

  it 'e não há preços sazonais configurados' do
    admin = create(:user, email: 'admin@punti.com')

    login_as admin

    visit seasonal_prices_path

    expect(page).to have_content 'Nenhum preço sazonal configurado.'
  end

  it 'e usuário comum não tem acesso' do
    user = create(:user)

    login_as user

    visit seasonal_prices_path

    expect(page).to have_content 'Você não possui acesso a este módulo'
  end

  it 'e não tem acesso se não estiver logado' do
    visit seasonal_prices_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end
end
