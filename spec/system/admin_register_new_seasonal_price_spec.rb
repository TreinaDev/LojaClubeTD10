require 'rails_helper'

describe 'Administrador cadastra novo preço sazonal' do
  it 'com sucesso' do
    user = create(:user, email: 'admin@punti.com')
    product = create(:product)
    start_date = 2.days.from_now.to_date
    end_date = 4.days.from_now.to_date

    login_as user
    visit seasonal_prices_path
    click_on 'Cadastrar preço sazonal'

    fill_in 'Valor', with: 9.99
    fill_in 'Data de início', with: start_date
    fill_in 'Data de encerramento', with: end_date
    select product.name, from: 'Produto'
    click_on 'Cadastrar'

    expect(current_path).to eq seasonal_prices_path
    expect(page).to have_content 'Preço sazonal criado com sucesso'
    expect(page).to have_link product.name
    expect(page).to have_content I18n.l(start_date)
    expect(page).to have_content I18n.l(end_date)
    expect(page).to have_content 'R$ 9,99'
  end

  it 'com informações incorretas' do
    user = create(:user, email: 'admin@punti.com')

    login_as user
    visit seasonal_prices_path
    click_on 'Cadastrar preço sazonal'
    click_on 'Cadastrar'

    expect(page).to have_content 'Não foi possível cadastrar preço sazonal, revise os campos'
    expect(page).to have_content 'Valor não pode ficar em branco'
    expect(page).to have_content 'Data de início não pode ficar em branco'
    expect(page).to have_content 'Data de encerramento não pode ficar em branco'
    expect(page).to have_content 'Produto é obrigatório(a)'
  end

  it 'com preço sazonal maior ou igual preço do produto' do
    user = create(:user, email: 'admin@punti.com')
    product = create(:product, price: 100)

    login_as user
    visit seasonal_prices_path
    click_on 'Cadastrar preço sazonal'

    fill_in 'Valor', with: '105'
    select product.name, from: 'Produto'

    click_on 'Cadastrar'

    expect(current_path).to eq seasonal_prices_path
    expect(page).to have_content 'Valor não pode ser maior ou igual ao preço de produto'
  end

  it 'com sobreposição de datas' do
    skip 'Implementar aqui'
  end
end
