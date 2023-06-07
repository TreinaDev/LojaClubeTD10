require 'rails_helper'

describe 'Usuário entra no sistema' do
  it 'e faz login' do
    FactoryBot.create(:user, email: 'zezinho@mail.com', password: 'f4k3p455w0rd')

    visit new_user_session_path

    fill_in 'E-mail', with: 'zezinho@mail.com'
    fill_in 'Senha', with: 'f4k3p455w0rd'
    click_on 'Entrar'

    expect(page).to have_content 'Logado com sucesso.'
    expect(page).to have_button 'Sair'
  end

  it 'com informações incorretas' do
    FactoryBot.create(:user, email: 'zezinho@mail.com', password: 'f4k3p455w0rd')

    visit new_user_session_path

    fill_in 'E-mail', with: 'zezezinho@mail.com'
    fill_in 'Senha', with: 'f4k3p455w0rd'
    click_on 'Entrar'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'E-mail ou senha inválidos.'
    expect(page).not_to have_button 'Sair'
  end

  it 'e faz logout' do
    # Arrange
    user = FactoryBot.create(:user)

    # Act
    login_as user
    visit root_path
    click_on 'Sair'

    # Assert
    expect(page).to have_content 'Até breve!.'
  end
end
