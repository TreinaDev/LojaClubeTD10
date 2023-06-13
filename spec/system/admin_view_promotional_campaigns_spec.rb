require 'rails_helper'

describe 'Administrador acessa index de campanhas promocionais' do
  it 'e vê a lista de campanhas promocionais' do
    user = User.create!(name: 'Usuário Administrador', email: 'admin@punti.com', password: 'senha1234',
                        phone_number: '19998555544', cpf: '56685728701')

    login_as user
    visit promotional_campaigns_path

    expect(page).to have_content 'Campanhas Promocionais'
    expect(page).to have_content 'Campanha: Natal 2023'
    expect(page).to have_content 'Empresa: CodeCampus'
    expect(page).to have_content 'Desconto: 10%'
    expect(page).to have_content 'Data de início: 01/12/2023'
    expect(page).to have_content 'Data de término: 31/12/2023'
    expect(page).to have_content 'Categoria: Eletrônicos'
  end
end
