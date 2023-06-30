require 'rails_helper'

describe 'Administrador edita uma campanha promocional' do
  it 'a partir da listagem de campanhas' do
    admin = create(:user, email: 'admin@punti.com')
    create(:promotional_campaign)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    find_link('Editar', id: 'promotional_campaign_1').click

    expect(current_path).to eq edit_promotional_campaign_path(1)
    expect(page).to have_field('Nome')
    expect(page).to have_field('Data Inicial')
    expect(page).to have_field('Data Final')
    expect(page).to have_select('Empresa')
  end

  it 'com sucesso' do
    admin = create(:user, email: 'admin@punti.com')
    create(:company, brand_name: 'PlayCode', registration_number: '90155816000187')
    create(:promotional_campaign)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    find_link('Editar', id: 'promotional_campaign_1').click

    fill_in 'Nome', with: 'Eletrofest 2023'
    fill_in 'Data Inicial', with: 1.week.from_now
    fill_in 'Data Final', with: 1.month.from_now
    select 'PlayCode', from: 'Empresa'
    click_on 'Cadastrar'

    expect(page).to have_content 'Campanha Promocional alterada com sucesso'
    expect(page).to have_content 'PlayCode'
    expect(page).to have_content 'Eletrofest 2023'
    expect(page).to have_content I18n.l(1.week.from_now.to_date)
    expect(page).to have_content I18n.l(1.month.from_now.to_date)
  end

  it 'com dados incompletos' do
    admin = create(:user, email: 'admin@punti.com')
    create(:company, brand_name: 'PlayCode', registration_number: '90155816000187')
    create(:promotional_campaign)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    find_link('Editar', id: 'promotional_campaign_1').click

    fill_in 'Nome', with: ''
    fill_in 'Data Inicial', with: ''
    fill_in 'Data Final', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content 'Não foi possível alterar a Campanha Promocional'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Data Inicial não pode ficar em branco'
    expect(page).to have_content 'Data Final não pode ficar em branco'
  end

  it 'como visitante tenta acessar, mas é direcionado para logar' do
    promotional_campaign = create(:promotional_campaign)

    visit edit_promotional_campaign_path(promotional_campaign.id)

    expect(current_path).to eq new_user_session_path
    expect(page).not_to have_field('Nome')
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end

  it 'como usuário comum tenta acessar, mas não tem acesso e é direcionado para o root' do
    user = create(:user)
    create(:company, brand_name: 'PlayCode', registration_number: '90155816000187')
    promotional_campaign = create(:promotional_campaign)

    login_as(user)
    visit edit_promotional_campaign_path(promotional_campaign.id)

    expect(current_path).to eq root_path
    expect(page).not_to have_field('Nome')
    expect(page).to have_content 'Você não possui acesso a este módulo'
  end

  it 'e não consegue editar uma campanha em andamento' do
    admin = create(:user, email: 'adm@punti.com')
    company = create(:company, brand_name: 'CodeCampus')
    travel_to 6.months.ago do
      create(:promotional_campaign, name: 'Verão 2023')
    end
    travel_to 1.month.ago do
      create(:promotional_campaign, name: 'Inverno 2023', end_date: 3.months.from_now.to_date)
    end
    create(:promotional_campaign, name: 'Outono 2023', company:)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'

    expect(page).to have_content 'Campanhas Promocionais'
    within '#campaigns_in_progress' do
      expect(page).to have_content 'Campanhas em andamento'
      expect(page).to have_content 'Inverno 2023'
      expect(page).not_to have_link 'Editar'
    end
    within '#campaigns_future' do
      expect(page).to have_content 'Campanhas futuras'
      expect(page).to have_content 'Outono 2023'
    end
    within '#campaigns_finished' do
      expect(page).to have_content 'Campanhas finalizadas'
      expect(page).to have_content 'Verão 2023'
    end
  end

  it 'e não consegue editar uma campanha finalizada' do
    admin = create(:user, email: 'adm@punti.com')
    company = create(:company, brand_name: 'CodeCampus')
    travel_to 6.months.ago do
      create(:promotional_campaign, name: 'Verão 2023')
    end
    travel_to 1.month.ago do
      create(:promotional_campaign, name: 'Inverno 2023', end_date: 3.months.from_now.to_date)
    end
    create(:promotional_campaign, name: 'Outono 2023', company:)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'

    expect(page).to have_content 'Campanhas Promocionais'
    within '#campaigns_in_progress' do
      expect(page).to have_content 'Campanhas em andamento'
      expect(page).to have_content 'Inverno 2023'
    end
    within '#campaigns_future' do
      expect(page).to have_content 'Campanhas futuras'
      expect(page).to have_content 'Outono 2023'
    end
    within '#campaigns_finished' do
      expect(page).to have_content 'Campanhas finalizadas'
      expect(page).to have_content 'Verão 2023'
      expect(page).not_to have_link 'Editar'
    end
  end
end
