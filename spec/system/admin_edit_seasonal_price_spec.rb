require 'rails_helper'

describe 'Administrador edita preço sazonal' do
  it 'com sucesso' do
    user = create(:user, email: 'admin@punti.com')
    product = create(:product, code: 'def123456')
    seasonal_price = create(:seasonal_price)
    create(:seasonal_price, product:)
    start_date = 2.days.from_now.to_date
    end_date = 4.days.from_now.to_date

    login_as user
    visit seasonal_prices_path

    click_button('Editar', id: "seasonal_price_#{seasonal_price.id}")

    fill_in 'Valor', with: 9.99
    fill_in 'Data de início', with: start_date
    fill_in 'Data de encerramento', with: end_date
    click_on 'Salvar'

    expect(current_path).to eq seasonal_prices_path
    expect(page).to have_content 'Preço sazonal atualizado com sucesso'
    expect(page).to have_link product.name
    expect(page).to have_content I18n.l(start_date)
    expect(page).to have_content I18n.l(end_date)
    expect(page).to have_content 'R$ 9,99'
  end

  it 'com informações incorretas' do
    user = create(:user, email: 'admin@punti.com')
    product = create(:product, code: 'def123456')
    seasonal_price = create(:seasonal_price)
    create(:seasonal_price, product:)

    login_as user
    visit seasonal_prices_path

    click_button('Editar', id: "seasonal_price_#{seasonal_price.id}")

    fill_in 'Valor', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível atualizar preço sazonal, revise os campos'
    expect(page).to have_content 'Valor não pode ficar em branco'
  end

  it 'com preço sazonal maior ou igual preço do produto' do
    user = create(:user, email: 'admin@punti.com')
    product = create(:product, code: 'def123456', price: 100)
    seasonal_price = create(:seasonal_price, product:, value: 90)
    create(:seasonal_price)

    login_as user
    visit seasonal_prices_path

    click_button('Editar', id: "seasonal_price_#{seasonal_price.id}")

    fill_in 'Valor', with: '105'
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível atualizar preço sazonal, revise os campos'
    expect(page).to have_content 'Valor não pode ser maior ou igual ao preço de produto'
  end
end
