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

    visit promotional_campaigns_path

    expect(page).to have_content 'Campanhas Promocionais'
    expect(page).to have_content 'Campanha'
    expect(page).to have_content 'Natal 2023'
    expect(page).to have_content 'Nome Fantasia'
    expect(page).to have_content 'CodeCampus'
    expect(page).to have_content 'Data Inicial'
    expect(page).to have_content '01/12/2023'
    expect(page).to have_content 'Data Final'
    expect(page).to have_content '31/12/2023'
  end
end
