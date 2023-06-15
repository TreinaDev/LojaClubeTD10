require 'rails_helper'

describe 'Administrador acessa index de campanhas promocionais' do
  it 'e vê a lista de campanhas promocionais' do
    user = FactoryBot.create(:user, email: 'adm@punti.com')

    company = Company.create!(brand_name: 'CodeCampus', registration_number: '45918500000145',
                              corporate_name: 'CodeCampus LTDA.')
    PromotionalCampaign.create!(name: 'Natal 2023', company:, start_date: 1.week.from_now.to_date,
                                end_date: 1.month.from_now.to_date)
    PromotionalCampaign.create!(name: 'Verão 2023', company:, start_date: 2.weeks.from_now.to_date,
                                end_date: 2.months.from_now.to_date)

    login_as(user)
    visit root_path
    click_on 'Campanhas'

    expect(page).to have_content 'Campanhas Promocionais'
    expect(page).to have_content 'Campanha'
    expect(page).to have_content 'Data Inicial'
    expect(page).to have_content 'Nome Fantasia'
    expect(page).to have_content 'CodeCampus'
    expect(page).to have_content 'Data Final'
    expect(page).to have_content 'Natal 2023'
    expect(page).to have_content I18n.l(1.week.from_now.to_date)
    expect(page).to have_content I18n.l(1.month.from_now.to_date)
    expect(page).to have_content 'Verão 2023'
    expect(page).to have_content I18n.l(2.weeks.from_now.to_date)
    expect(page).to have_content I18n.l(2.months.from_now.to_date)
  end

  it 'e não tem campanhas promocionais cadastradas' do
    user = FactoryBot.create(:user, email: 'adm@punti.com')

    login_as(user)
    visit promotional_campaigns_path

    expect(page).to have_content 'Campanhas Promocionais'
    expect(page).to have_content 'Não existem Campanhas Promocionais cadastradas'
  end

  it 'como visitante tenta acessar, mas é direcionado para logar' do
    visit root_path
    visit promotional_campaigns_path

    expect(current_path).to eq new_user_session_path
    expect(page).not_to have_content 'Campanhas Promocionais'
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end

  it 'como usuário comum tenta acessar, mas não tem acesso e é direcionado para o root' do
    user = FactoryBot.create(:user)

    login_as(user)
    visit root_path
    visit promotional_campaigns_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este módulo'
  end
end
