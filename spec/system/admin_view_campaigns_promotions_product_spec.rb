require 'rails_helper'

describe 'Administrador vê as campanhas e promoções do produto' do
  it 'a partir da lista de produtos e tem campanhas e preços sazonais para o produto' do
    admin = create(:user, email: 'admin@punti.com')
    category = create(:product_category, name: 'TV')
    product = create(:product, name: 'TV SAMSUNG', code: 'TVS000001', price: 3000, product_category: category)
    create(:seasonal_price, product:, value: 1000, start_date: 2.days.from_now,
                            end_date: 3.days.from_now)
    company = create(:company, brand_name: 'Vindi')
    campaign = create(:promotional_campaign, name: 'Primavera 2023', company:, start_date: 2.months.from_now,
                                             end_date: 3.months.from_now)
    create(:campaign_category, promotional_campaign: campaign, product_category: category, discount: 20)

    login_as(admin)
    visit root_path
    click_on 'Produtos'
    find_link('Campanhas e Promoções', id: 'product_1').click

    expect(page).to have_content 'Produto TVS000001 - TV SAMSUNG'
    expect(page).to have_link 'Novo Preço Sazonal'
    expect(page).to have_content 'Preços Sazonais aplicados a esse produto'
    expect(page).to have_content 'Data de início'
    expect(page).to have_content 'Data de encerramento'
    expect(page).to have_content 'Valor'
    expect(page).to have_content I18n.l(2.days.from_now.to_date)
    expect(page).to have_content I18n.l(3.days.from_now.to_date)
    expect(page).to have_content 'R$ 1.000,00'
    expect(page).to have_content 'Campanhas aplicadas à categoria desse produto'
    expect(page).to have_content 'Nome'
    expect(page).to have_content 'Nome Fantasia'
    expect(page).to have_content 'Data Inicial'
    expect(page).to have_content 'Data Final'
    expect(page).to have_content 'Desconto'
    expect(page).to have_content 'Primavera 2023'
    expect(page).to have_content 'Vindi'
    expect(page).to have_content I18n.l(2.months.from_now.to_date)
    expect(page).to have_content I18n.l(3.months.from_now.to_date)
    expect(page).to have_content '20% de desconto'
  end

  it 'a partir da lista de produtos e tem somente campanhas para o produto' do
    admin = create(:user, email: 'admin@punti.com')
    category = create(:product_category, name: 'TV')
    create(:product, name: 'TV SAMSUNG', code: 'TVS000001', price: 3000, product_category: category)
    company = create(:company, brand_name: 'Vindi')
    campaign = create(:promotional_campaign, name: 'Primavera 2023', company:, start_date: 2.months.from_now,
                                             end_date: 3.months.from_now)
    create(:campaign_category, promotional_campaign: campaign, product_category: category, discount: 20)

    login_as(admin)
    visit root_path
    click_on 'Produtos'
    find_link('Campanhas e Promoções', id: 'product_1').click

    expect(page).to have_content 'Produto TVS000001 - TV SAMSUNG'
    expect(page).to have_link 'Novo Preço Sazonal'
    expect(page).to have_content 'Preços Sazonais aplicados a esse produto'
    expect(page).to have_content 'Não existem Preços Sazonais aplicados a esse produto'
    expect(page).not_to have_content 'Data de início'
    expect(page).not_to have_content 'Data de encerramento'
    expect(page).not_to have_content 'Valor'
    expect(page).to have_content 'Campanhas aplicadas à categoria desse produto'
    expect(page).to have_content 'Nome'
    expect(page).to have_content 'Nome Fantasia'
    expect(page).to have_content 'Data Inicial'
    expect(page).to have_content 'Data Final'
    expect(page).to have_content 'Desconto'
    expect(page).to have_content 'Primavera 2023'
    expect(page).to have_content 'Vindi'
    expect(page).to have_content I18n.l(2.months.from_now.to_date)
    expect(page).to have_content I18n.l(3.months.from_now.to_date)
    expect(page).to have_content '20% de desconto'
  end

  it 'a partir da lista de produtos e tem somente preços sazonais para o produto' do
    admin = create(:user, email: 'admin@punti.com')
    category = create(:product_category, name: 'TV')
    product = create(:product, name: 'TV SAMSUNG', code: 'TVS000001', price: 3000, product_category: category)
    create(:seasonal_price, product:, value: 1000, start_date: 2.days.from_now,
                            end_date: 3.days.from_now)

    login_as(admin)
    visit root_path
    click_on 'Produtos'
    find_link('Campanhas e Promoções', id: 'product_1').click

    expect(page).to have_content 'Produto TVS000001 - TV SAMSUNG'
    expect(page).to have_link 'Novo Preço Sazonal'
    expect(page).to have_content 'Preços Sazonais aplicados a esse produto'
    expect(page).to have_content 'Data de início'
    expect(page).to have_content 'Data de encerramento'
    expect(page).to have_content 'Valor'
    expect(page).to have_content I18n.l(2.days.from_now.to_date)
    expect(page).to have_content I18n.l(3.days.from_now.to_date)
    expect(page).to have_content 'R$ 1.000,00'
    expect(page).to have_content 'Campanhas aplicadas à categoria desse produto'
    expect(page).to have_content 'Não existem Campanhas aplicadas à categoria desse produto'
    expect(page).not_to have_content 'Nome'
    expect(page).not_to have_content 'Nome Fantasia'
    expect(page).not_to have_content 'Data Inicial'
    expect(page).not_to have_content 'Data Final'
    expect(page).not_to have_content 'Desconto'
  end

  it 'como visitante tenta acessar, mas é direcionado para logar' do
    visit products_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end

  it 'como usuário comum tenta acessar, mas não tem acesso e é direcionado para o root' do
    user = create(:user)

    login_as(user)
    visit products_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este módulo'
  end
end
