require 'rails_helper'

describe 'Usuário entra no sistema' do
  it 'e faz login' do
    create(:user, email: 'zezinho@mail.com', password: 'f4k3p455w0rd')

    visit new_user_session_path

    within 'form#new_user' do
      fill_in 'E-mail', with: 'zezinho@mail.com'
      fill_in 'Senha', with: 'f4k3p455w0rd'
      click_on 'Entrar'
    end

    expect(page).to have_content 'Logado com sucesso.'
    expect(page).to have_button 'Sair'
  end
  it 'e faz login, atualizando as informações do cartão' do
    user = create(:user, email: 'zezinho@mail.com', password: 'f4k3p455w0rd')
    create(:card_info, user:, conversion_tax: '50.0')
    json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(fake_response)

    visit new_user_session_path
    within 'form#new_user' do
      fill_in 'E-mail', with: 'zezinho@mail.com'
      fill_in 'Senha', with: 'f4k3p455w0rd'
      click_on 'Entrar'
    end

    user.card_info.reload
    expect(user.card_info.conversion_tax).to eq '20.0'
    expect(page).to have_content 'Logado com sucesso.'
    expect(page).to have_button 'Sair'
  end

  it 'com informações incorretas' do
    create(:user, email: 'zezinho@mail.com', password: 'f4k3p455w0rd')

    visit new_user_session_path
    within 'form#new_user' do
      fill_in 'E-mail', with: 'zezezinho@mail.com'
      fill_in 'Senha', with: 'f4k3p455w0rd'
      click_on 'Entrar'
    end

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'E-mail ou senha inválidos.'
    expect(page).not_to have_button 'Sair'
  end

  it 'e faz logout' do
    user = create(:user)

    login_as user
    visit root_path
    click_on 'Sair'

    expect(page).to have_content 'Até breve!'
  end
end
