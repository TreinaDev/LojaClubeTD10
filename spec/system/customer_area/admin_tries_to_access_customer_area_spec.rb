require 'rails_helper'

describe 'Administrador tenta acessar área do cliente' do
  it 'e não consegue' do
    user_admin = FactoryBot.create(:user, email: 'josé@punti.com', role: 1)

    login_as(user_admin)
    visit root_path
    click_on 'Área do Cliente'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Administrador não tem acesso a essa página'
  end
end
