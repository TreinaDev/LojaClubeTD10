require 'rails_helper'

describe 'Administrador cadastra novo preço sazonal' do
  context 'a partir da lista de produtos' do
    it 'com sucesso' do
      admin = create(:user, email: 'admin@punti.com')
      product = create(:product)
      start_date = 2.days.from_now.to_date
      end_date = 4.days.from_now.to_date

      login_as(admin)
      visit root_path
      click_on 'Produtos'
      find_link('Cadastrar preço sazonal', id: 'product_1').click
      fill_in 'Valor', with: 9.99
      fill_in 'Data de início', with: start_date
      fill_in 'Data de encerramento', with: end_date
      click_on 'Cadastrar'

      expect(current_path).to eq campaigns_promotions_product_path(product.id)
      expect(page).to have_content 'Preço sazonal criado com sucesso'
      expect(page).to have_content I18n.l(start_date)
      expect(page).to have_content I18n.l(end_date)
      expect(page).to have_content 'R$ 9,99'
    end

    it 'com informações incorretas' do
      admin = create(:user, email: 'admin@punti.com')
      create(:product)

      login_as(admin)
      visit root_path
      click_on 'Produtos'
      find_link('Cadastrar preço sazonal', id: 'product_1').click
      click_on 'Cadastrar'

      expect(page).to have_content 'Não foi possível cadastrar preço sazonal, revise os campos'
      expect(page).to have_content 'Valor não pode ficar em branco'
      expect(page).to have_content 'Data de início não pode ficar em branco'
      expect(page).to have_content 'Data de encerramento não pode ficar em branco'
    end

    it 'com preço sazonal maior ou igual preço do produto' do
      admin = create(:user, email: 'admin@punti.com')
      create(:product, price: 100)
      start_date = 2.days.from_now.to_date
      end_date = 4.days.from_now.to_date

      login_as(admin)
      visit root_path
      click_on 'Produtos'
      find_link('Cadastrar preço sazonal', id: 'product_1').click
      fill_in 'Valor', with: 105
      fill_in 'Data de início', with: start_date
      fill_in 'Data de encerramento', with: end_date
      click_on 'Cadastrar'

      expect(current_path).to eq seasonal_prices_path
      expect(page).to have_content 'Valor não pode ser maior ou igual ao preço de produto'
    end
  end

  context 'a partir da página de campanhas e preços sazonais do produto' do
    it 'e tem campanhas e preços sazonais para o produto, com sucesso' do
      admin = create(:user, email: 'admin@punti.com')
      category = create(:product_category, name: 'TV')
      product = create(:product, name: 'TV SAMSUNG', code: 'TVS000001', price: 3000, product_category: category)
      create(:seasonal_price, product:, value: 1000, start_date: 2.days.from_now,
                              end_date: 3.days.from_now)
      company = create(:company, brand_name: 'Vindi')
      campaign = create(:promotional_campaign, name: 'Primavera 2023', company:, start_date: 2.months.from_now,
                                               end_date: 3.months.from_now)
      create(:campaign_category, promotional_campaign: campaign, product_category: category, discount: 20)
      start_date = 2.months.from_now.to_date
      end_date = 4.months.from_now.to_date

      login_as(admin)
      visit root_path
      click_on 'Produtos'
      find_link('Campanhas e Promoções', id: 'product_1').click
      click_on 'Novo Preço Sazonal'
      fill_in 'Valor', with: 9.99
      fill_in 'Data de início', with: start_date
      fill_in 'Data de encerramento', with: end_date
      click_on 'Cadastrar'

      expect(current_path).to eq campaigns_promotions_product_path(product.id)
      expect(page).to have_content 'Preço sazonal criado com sucesso'
      expect(page).to have_content I18n.l(start_date)
      expect(page).to have_content I18n.l(end_date)
      expect(page).to have_content 'R$ 9,99'
    end

    it 'e tem somente campanhas para o produto, com sucesso' do
      admin = create(:user, email: 'admin@punti.com')
      category = create(:product_category, name: 'TV')
      product = create(:product, name: 'TV SAMSUNG', code: 'TVS000001', price: 3000, product_category: category)
      company = create(:company, brand_name: 'Vindi')
      campaign = create(:promotional_campaign, name: 'Primavera 2023', company:, start_date: 2.months.from_now,
                                               end_date: 3.months.from_now)
      create(:campaign_category, promotional_campaign: campaign, product_category: category, discount: 20)
      start_date = 2.months.from_now.to_date
      end_date = 4.months.from_now.to_date

      login_as(admin)
      visit root_path
      click_on 'Produtos'
      find_link('Campanhas e Promoções', id: 'product_1').click
      click_on 'Novo Preço Sazonal'
      fill_in 'Valor', with: 9.99
      fill_in 'Data de início', with: start_date
      fill_in 'Data de encerramento', with: end_date
      click_on 'Cadastrar'

      expect(current_path).to eq campaigns_promotions_product_path(product.id)
      expect(page).to have_content 'Preço sazonal criado com sucesso'
      expect(page).to have_content I18n.l(start_date)
      expect(page).to have_content I18n.l(end_date)
      expect(page).to have_content 'R$ 9,99'
    end

    it 'e tem somente preços sazonais para o produto, com sucesso' do
      admin = create(:user, email: 'admin@punti.com')
      category = create(:product_category, name: 'TV')
      product = create(:product, name: 'TV SAMSUNG', code: 'TVS000001', price: 3000, product_category: category)
      create(:seasonal_price, product:, value: 1000, start_date: 2.days.from_now,
                              end_date: 3.days.from_now)
      start_date = 2.months.from_now.to_date
      end_date = 4.months.from_now.to_date

      login_as(admin)
      visit root_path
      click_on 'Produtos'
      find_link('Campanhas e Promoções', id: 'product_1').click
      click_on 'Novo Preço Sazonal'
      fill_in 'Valor', with: 9.99
      fill_in 'Data de início', with: start_date
      fill_in 'Data de encerramento', with: end_date
      click_on 'Cadastrar'

      expect(current_path).to eq campaigns_promotions_product_path(product.id)
      expect(page).to have_content 'Preço sazonal criado com sucesso'
      expect(page).to have_content I18n.l(start_date)
      expect(page).to have_content I18n.l(end_date)
      expect(page).to have_content 'R$ 9,99'
    end
  end

  it 'como visitante' do
    create(:product)

    visit new_seasonal_price_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end

  it 'como usuário comum' do
    user = create(:user)
    create(:product)

    login_as(user)
    visit new_seasonal_price_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este módulo'
  end
end
