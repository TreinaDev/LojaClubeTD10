require 'rails_helper'

describe 'Usuário visita minhas informações' do
  it 'apenas estando autenticado' do
    visit me_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end
  it 'a partir do link na Área do Cliente' do
    user = FactoryBot.create(:user, name: 'José', email: 'jose@gmail.com', password: 'jose1234', cpf: '60789974088',
                                    phone_number: '85999923132')

    login_as(user)
    visit root_path
    click_on 'Área do Cliente'

    expect(page).to have_link 'Minhas Informações'
  end
  it 'com sucesso' do
    user = FactoryBot.create(:user, name: 'José', email: 'jose@gmail.com', password: 'jose1234', cpf: '60789974088',
                                    phone_number: '85999923132')

    login_as(user)
    visit root_path
    click_on 'Área do Cliente'
    click_on 'Minhas Informações'

    expect(current_path).to eq me_path
    expect(page).to have_content 'Nome'
    expect(page).to have_content 'José'
    expect(page).to have_content 'E-mail'
    expect(page).to have_content 'jose@gmail.com'
    expect(page).to have_content 'CPF'
    expect(page).to have_content '607.899.740-88'
    expect(page).to have_content 'Número de telefone'
    expect(page).to have_field 'phone_number', with: '(85)99992-3132'
  end
  it 'e sendo administrador não consegue' do
    user = FactoryBot.create(:user, name: 'José', email: 'jose@punti.com', role: 1)

    login_as(user)
    visit me_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Administrador não tem acesso a essa página'
  end
end
