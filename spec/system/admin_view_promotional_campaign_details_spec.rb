require 'rails_helper'

describe 'Administrador acessa detalhes de uma campanha promocional' do
  it 'a partir da listagem de campanhas promocional' do
    user = FactoryBot.create(:user, email: 'adm@punti.com')
    company = FactoryBot.create(:company)
    PromotionalCampaign.create!(name: 'Natal 2023', company:, start_date: 1.week.from_now, end_date: 1.month.from_now)

    login_as(user)
    visit root_path
    click_on 'Campanhas'
    click_on 'Natal 2023'

    expect(page).to have_content 'Natal 2023'
    expect(page).to have_content I18n.l(1.week.from_now.to_date)
    expect(page).to have_content I18n.l(1.month.from_now.to_date)
    expect(page).to have_content 'CodeCampus'
  end

  it 'como visitante tenta acessar, mas é direcionado para logar' do
    company = FactoryBot.create(:company)
    promotional_campaign = PromotionalCampaign.create!(name: 'Verão 2023', company:,
                                                       start_date: 1.week.from_now, end_date: 1.month.from_now)
    PromotionalCampaign.create!(name: 'Natal 2023', company:,
                                start_date: 5.months.from_now, end_date: 6.months.from_now)

    visit root_path
    visit promotional_campaign_path(promotional_campaign.id)

    expect(current_path).to eq new_user_session_path
    expect(page).not_to have_content 'Campanhas Promocionais'
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end

  it 'como usuário comum tenta acessar, mas não tem acesso e é direcionado para o root' do
    user = FactoryBot.create(:user)
    company = FactoryBot.create(:company)
    promotional_campaign = PromotionalCampaign.create!(name: 'Verão 2023', company:,
                                                       start_date: 1.week.from_now, end_date: 1.month.from_now)
    PromotionalCampaign.create!(name: 'Natal 2023', company:,
                                start_date: 5.months.from_now, end_date: 6.months.from_now)

    login_as(user)
    visit root_path
    visit promotional_campaign_path(promotional_campaign.id)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este módulo'
  end
end
