require 'rails_helper'

describe 'Usuário entra no sistema' do
  it 'e cria uma conta' do
    # Arrange

    # Act
    visit new_user_registration_path
    fill_in 'Nome', with: 'João'
    fill_in 'E-mail', with: 'joao@ig.com.br'
    fill_in 'CPF', with: '26502001033'
    fill_in 'Número de telefone', with: '19999999999'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme a senha', with: 'password'
    click_on 'Registrar'

    # Assert

    expect(current_path).to eq root_path
    expect(page).to have_content 'Bem vindo! Você se registrou com sucesso.'
    expect(page).not_to have_content 'administrador'
  end

  it 'e cria uma conta administradora' do
    visit new_user_registration_path
    fill_in 'Nome', with: 'Aldaberto'
    fill_in 'E-mail', with: 'aldaberto@punti.com'
    fill_in 'CPF', with: '73962060065'
    fill_in 'Número de telefone', with: '79981546487'
    fill_in 'Senha', with: 'f4k3p455w0rd'
    fill_in 'Confirme a senha', with: 'f4k3p455w0rd'
    click_on 'Registrar'

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'administrador'
  end
end
