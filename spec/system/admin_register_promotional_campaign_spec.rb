require 'rails_helper'

describe 'Admin registra uma nova Campanha Promocional' do
  it 'com sucesso' do
    admin = create(:user, email: 'admin@punti.com')
    create(:company)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    click_on 'Nova Campanha Promocional'
    fill_in 'Nome', with: 'Verão 2023'
    fill_in 'Data Inicial', with: 1.week.from_now.to_date
    fill_in 'Data Final', with: 1.month.from_now.to_date
    select 'CodeCampus', from: 'Empresa'
    click_on 'Cadastrar'

    expect(page).to have_content 'Campanha Promocional'
    expect(page).to have_content 'Campanha Promocional cadastrada com sucesso'
  end

  it 'com dados incompletos' do
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    click_on 'Nova Campanha Promocional'
    fill_in 'Nome', with: ''
    fill_in 'Data Inicial', with: ''
    fill_in 'Data Final', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content 'Não foi possível cadastrar a Campanha Promocional'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Empresa é obrigatório(a)'
    expect(page).to have_content 'Data Inicial não pode ficar em branco'
    expect(page).to have_content 'Data Final não pode ficar em branco'
  end

  it 'como visitante tenta acessar, mas é direcionado para logar' do
    visit new_promotional_campaign_path

    expect(current_path).to eq new_user_session_path
    expect(page).not_to have_field('Nome')
    expect(page).not_to have_field('Nome Fantasia', with: 'CodeCampus')
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end

  it 'como usuário comum tenta acessar, mas não tem acesso e é direcionado para o root' do
    user = create(:user)

    login_as(user)
    visit new_promotional_campaign_path

    expect(current_path).to eq root_path
    expect(page).not_to have_field('Nome')
    expect(page).not_to have_field('Nome Fantasia', with: 'CodeCampus')
    expect(page).to have_content 'Você não possui acesso a este módulo'
  end
end
