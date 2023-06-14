require 'rails_helper'

describe 'Admin registra uma nova Campanha Promocional' do
  it 'com sucesso' do
    admin = FactoryBot.create(:user, email: 'admin@punti.com')
    FactoryBot.create(:company)

    login_as(admin)
    visit promotional_campaigns_path
    click_on 'Nova Campanha Promocional'
    fill_in 'Nome', with: 'Verão 2023'
    fill_in 'Data Inicial', with: '23/09/2023'
    fill_in 'Data Final', with: '23/10/2023'
    select 'CodeCampus', from: 'Empresa'
    click_on 'Cadastrar'

    expect(page).to have_content 'Campanha Promocional'
    expect(page).to have_content 'Campanha Promocional cadastrada com sucesso'
  end

  it 'com dados incompletos' do
    admin = FactoryBot.create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit promotional_campaigns_path
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

  it 'como visitante' do
    visit root_path
    visit new_promotional_campaign_path

    expect(current_path).to eq new_user_session_path
    expect(page).not_to have_field('Nome')
    expect(page).not_to have_field('Nome Fantasia', with: 'CodeCampus')
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end

  it 'como usuário comum' do
    user = User.create!(name: 'Maria Sousa', email: 'maria@provedor.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '66610881090')

    login_as(user)
    visit root_path
    visit new_promotional_campaign_path

    expect(current_path).to eq root_path
    expect(page).not_to have_field('Nome')
    expect(page).not_to have_field('Nome Fantasia', with: 'CodeCampus')
    expect(page).to have_content 'Você não possui acesso a este módulo'
  end
end
