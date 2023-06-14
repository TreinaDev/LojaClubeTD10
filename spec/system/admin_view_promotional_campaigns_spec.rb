require 'rails_helper'

describe 'Administrador acessa index de campanhas promocionais' do
  it 'e vê a lista de campanhas promocionais' do
    user = User.create!(name: 'Usuário Administrador', email: 'admin@punti.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')

    login_as(user)
    company = Company.create!(brand_name: 'CodeCampus', registration_number: '45918500000145',
                              corporate_name: 'CodeCampus LTDA.')
    PromotionalCampaign.create!(name: 'Natal 2023', company:, start_date: '01/12/2023',
                                end_date: '31/12/2023')
    PromotionalCampaign.create!(name: 'Verão 2023', company:, start_date: '23/09/2023',
                                end_date: '23/10/2023')

    visit promotional_campaigns_path

    expect(page).to have_content 'Campanhas Promocionais'
    expect(page).to have_content 'Campanha'
    expect(page).to have_content 'Data Inicial'
    expect(page).to have_content 'Nome Fantasia'
    expect(page).to have_content 'CodeCampus'
    expect(page).to have_content 'Data Final'
    expect(page).to have_content 'Natal 2023'
    expect(page).to have_content '01/12/2023'
    expect(page).to have_content '31/12/2023'
    expect(page).to have_content 'Verão 2023'
    expect(page).to have_content '23/09/2023'
    expect(page).to have_content '23/10/2023'
  end

  it 'e não tem campanhas promocionais cadastradas' do
    user = User.create!(name: 'Usuário Administrador', email: 'admin@punti.com', password: 'senha1234',
    phone_number: '19998555544', cpf: '56685728701')

    login_as(user)
    visit promotional_campaigns_path
    
    expect(page).to have_content 'Campanhas Promocionais'
    expect(page).to have_content 'Não existem Campanhas Promocionais cadastradas'
  end

  it 'como visitante' do
    visit root_path
    visit promotional_campaigns_path

    expect(current_path).to eq new_user_session_path
    expect(page).not_to have_content 'Campanhas Promocionais'
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end

  it 'como usuário comum' do
    user = User.create!(name: 'Maria Sousa', email: 'maria@provedor.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '66610881090')

    login_as(user)
    visit root_path
    visit promotional_campaigns_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este módulo'
  end

end
