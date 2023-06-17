require 'rails_helper'

describe 'Administrador acessa detalhes de uma campanha promocional' do
  it 'a partir da listagem de campanhas promocional' do
    admin = create(:user, email: 'adm@punti.com')
    company = create(:company)
    create(:promotional_campaign, name: 'Natal 2023', company:, start_date: 1.week.from_now, end_date: 1.month.from_now)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    click_on 'Natal 2023'

    expect(page).to have_content 'Natal 2023'
    expect(page).to have_content I18n.l(1.week.from_now.to_date)
    expect(page).to have_content I18n.l(1.month.from_now.to_date)
    expect(page).to have_content 'CodeCampus'
  end

  it 'como visitante tenta acessar, mas é direcionado para logar' do
    company = create(:company)
    promotional_campaign = create(:promotional_campaign, company:)

    visit root_path
    visit promotional_campaign_path(promotional_campaign.id)

    expect(current_path).to eq new_user_session_path
    expect(page).not_to have_content 'Campanhas Promocionais'
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end

  it 'como usuário comum tenta acessar, mas não tem acesso e é direcionado para o root' do
    user = create(:user)
    company = create(:company)
    promotional_campaign = create(:promotional_campaign, company:)

    login_as(user)
    visit root_path
    visit promotional_campaign_path(promotional_campaign.id)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este módulo'
  end

  it 'e vê as categorias e seus respectivos descontos aplicados a essa campanha campanhas promocional' do
    admin = create(:user, email: 'adm@punti.com')
    category1 = create(:product_category, name: 'Celulares')
    category2 = create(:product_category, name: 'Eletrônicos')
    company = create(:company)
    promotional_campaign = create(:promotional_campaign, name: 'Natal 2023', company:, start_date: 1.week.from_now,
                                                         end_date: 1.month.from_now)
    CampaignCategory.create!(promotional_campaign:, product_category: category1, discount: 10)
    CampaignCategory.create!(promotional_campaign:, product_category: category2, discount: 20)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    click_on 'Natal 2023'

    expect(page).to have_content 'Natal 2023'
    expect(page).to have_content I18n.l(1.week.from_now.to_date)
    expect(page).to have_content I18n.l(1.month.from_now.to_date)
    expect(page).to have_content 'CodeCampus'
    expect(page).to have_content 'Categorias com desconto'
    expect(page).to have_content 'Celulares - 10% de desconto'
    expect(page).to have_content 'Eletrônicos - 20% de desconto'
  end
end
