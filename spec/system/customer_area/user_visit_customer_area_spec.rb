require 'rails_helper'

describe 'Usuário visita área do cliente' do
  it 'e vê a área do cliente' do
    user = FactoryBot.create(:user, name: 'José', email: 'jose@gmail.com', password: 'jose1234')

    login_as(user)
    visit root_path
    click_on 'Área do Cliente'

    expect(current_path).to eq customer_area_index_path
  end

  it 'e não está logado' do
    visit customer_area_index_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Você precisa fazer login ou se registrar antes de continuar')
  end
end
