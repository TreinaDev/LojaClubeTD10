require 'rails_helper'

describe 'Usuário entra no sistema' do
  it 'e faz login' do
    User.create!(
      name: 'José',
      email: 'zezinho@mail.com',
      cpf: '19540504023',
      phone_number: '1998555544',
      password: 'f4k3p455w0rd'
    )

    visit new_user_session_path

    fill_in 'E-mail', with: 'zezinho@mail.com'
    fill_in 'Senha', with: 'f4k3p455w0rd'
    click_on 'Entrar'

    expect(page).to have_content 'Logado com sucesso.'
    expect(page).to have_button 'Sair'
  end

  it 'e faz logout' do
    # Arrange
    user = User.create!(
      name: 'José',
      email: 'zezinho@mail.com',
      cpf: '19540504023',
      phone_number: '1998555544',
      password: 'f4k3p455w0rd'
    )

    # Act
    login_as user
    visit root_path
    click_on 'Sair'

    # Assert
    expect(page).to have_content 'Até breve!.'
  end
end
