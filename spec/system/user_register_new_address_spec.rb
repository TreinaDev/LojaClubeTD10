require 'rails_helper'

describe 'Usuário registra um novo endereço' do
  it 'através da página inicial' do
    user = create(:user)

    login_as(user)
    visit root_path
    click_on 'Área do Cliente'
    click_on 'Meus Endereços'
    click_on 'Cadastrar novo endereço'

    expect(current_path).to eq new_address_path
    expect(page).to have_field 'Endereço'
    expect(page).to have_field 'Número'
    expect(page).to have_field 'Cidade'
    expect(page).to have_field 'Estado'
    expect(page).to have_field 'CEP'
    expect(page).to have_button 'Salvar endereço'
  end

  it 'com sucesso, e se torna padrão caso seja o primeiro cadastrado' do
    user = create(:user)

    login_as(user)
    visit new_address_path
    fill_in 'Endereço', with: 'Rua Dr. Alcides Pereira'
    fill_in 'Número', with: '111'
    fill_in 'Cidade', with: 'Maruim'
    fill_in 'Estado', with: 'Sergipe'
    fill_in 'CEP', with: '49770000'
    click_on 'Salvar endereço'

    expect(current_path).to eq client_addresses_path
    expect(page).not_to have_button 'Selecionar como Padrão'
    expect(ClientAddress.last.default).to eq true
    expect(page).to have_content 'Rua Dr. Alcides Pereira, 111'
    expect(page).to have_content 'Maruim'
    expect(page).to have_content 'Sergipe'
    expect(page).to have_content '49770000'
  end

  it 'com sucesso, e não se torna padrão caso já tenha endereço cadastrado' do
    user = create(:user)
    address = create(:address)
    ClientAddress.create!(user:, address:)

    login_as(user)
    visit new_address_path
    fill_in 'Endereço', with: 'Rua Dr. Alcides Pereira'
    fill_in 'Número', with: '111'
    fill_in 'Cidade', with: 'Maruim'
    fill_in 'Estado', with: 'Sergipe'
    fill_in 'CEP', with: '49770000'
    click_on 'Salvar endereço'

    expect(current_path).to eq client_addresses_path
    expect(page).to have_button 'Selecionar como Padrão'
    expect(ClientAddress.last.default).to eq false
    expect(page).to have_content 'Rua Dr. Alcides Pereira, 111'
    expect(page).to have_content 'Maruim'
    expect(page).to have_content 'Sergipe'
    expect(page).to have_content '49770000'
  end

  it 'com informações incompletas' do
    user = create(:user)

    login_as(user)
    visit new_address_path
    fill_in 'Número', with: '111'
    fill_in 'CEP', with: '49770'
    click_on 'Salvar endereço'

    expect(page).to have_content 'Não foi possível salvar o endereço, revise os campos abaixo:'
    expect(page).to have_content 'CEP não possui o tamanho esperado (8 caracteres)'
    expect(page).to have_content 'Endereço não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'Estado não pode ficar em branco'
  end

  it 'como visitante e não tem acesso a página' do
    visit new_address_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end

  it 'como administrador e não tem acesso' do
    admin = create(:user, email: 'admin@punti.com')

    login_as(admin)
    visit new_address_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Administrador não tem acesso a essa página'
  end
end
