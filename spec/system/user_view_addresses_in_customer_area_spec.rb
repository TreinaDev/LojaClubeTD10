require 'rails_helper'

describe 'Usuário vê seus endereços na área do cliente' do
  it 'a partir da página inicial' do
    user = create(:user)
    address = create(:address, city: 'Maruim', state: 'Sergipe', zipcode: '49770000')
    create(:client_address, user:, address:)

    login_as(user)
    visit root_path
    click_on 'Área do Cliente'
    click_on 'Endereços Cadastrados'

    expect(page).to have_content 'Maruim'
    expect(page).to have_content 'Sergipe'
    expect(page).to have_content '49770000'
  end

  it 'e não vê endereços de outros usuários' do
    first_user = create(:user)
    second_user = create(:user, email: 'user@email.com', cpf: '56276041076')
    address = create(:address, city: 'Maruim', state: 'Sergipe', zipcode: '49770000')
    create(:client_address, user: first_user, address:)

    login_as(second_user)
    visit client_addresses_path

    expect(page).not_to have_content 'Maruim'
    expect(page).not_to have_content 'Sergipe'
    expect(page).not_to have_content '49770000'
  end

  it 'e remove um endereço' do
    user = create(:user)
    first_address = create(:address, city: 'Maruim', state: 'Sergipe', zipcode: '49770000')
    second_address = create(:address, city: 'Curitiba', state: 'Paraná', zipcode: '83430000')
    create(:client_address, user:, address: second_address)
    create(:client_address, user:, address: first_address)

    login_as(user)
    visit root_path
    click_on 'Área do Cliente'
    click_on 'Endereços Cadastrados'
    within ".controls form[action='/addresses/#{first_address.id}']" do
      click_on 'Remover'
    end

    expect(current_path).to eq client_addresses_path
    expect(user.addresses.count).to be 1
    expect(page).to have_content 'Curitiba'
    expect(page).to have_content 'Paraná'
    expect(page).to have_content '83430000'
    expect(page).not_to have_content 'Maruim'
    expect(page).not_to have_content 'Sergipe'
    expect(page).not_to have_content '49770000'
  end

  it 'e seleciona um endereço como padrão' do
    user = create(:user)

    first_address = create(:address, address: 'Rua Aquidabã', number: '115',
                                     city: 'Aracaju', state: 'Sergipe', zipcode: '48005000')
    second_address = create(:address, address: 'Rua Santo Antonio', number: '22',
                                      city: 'Maruim', state: 'Sergipe', zipcode: '49770000')

    ClientAddress.create!(user:, address: first_address)
    ClientAddress.create!(user:, address: second_address)

    login_as(user)
    visit root_path
    click_on 'Área do Cliente'
    click_on 'Endereços Cadastrados'

    within :xpath, '//div[div/p[text()="Rua Santo Antonio, 22"]]' do
      click_on 'Selecionar como Padrão'
    end

    within :xpath, '//div[div/p[text()="Rua Aquidabã, 115"]]' do
      expect(page).to have_button 'Selecionar como Padrão'
    end

    within :xpath, '//div[div/p[text()="Rua Santo Antonio, 22"]]' do
      expect(page).not_to have_button 'Selecionar como Padrão'
    end
  end

  it 'e vê endereço padrão no topo da lista' do
    user = create(:user)

    first_address = create(:address, address: 'Rua Aquidabã', number: '115',
                                     city: 'Aracaju', state: 'Sergipe', zipcode: '48005000')
    second_address = create(:address, address: 'Rua Santo Antonio', number: '22',
                                      city: 'Maruim', state: 'Sergipe', zipcode: '49770000')

    ClientAddress.create!(user:, address: first_address)
    ClientAddress.create!(user:, address: second_address, default: true)

    login_as(user)
    visit client_addresses_path

    within '.address-painel:first-child' do
      expect(page).to have_content 'Rua Santo Antonio, 22'
    end
  end

  it 'e como visitante não tem acesso' do
    visit client_addresses_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end

  it 'e como administrador não tem acesso' do
    admin = create(:user, cpf: '24034550082', email: 'admin@punti.com')

    login_as(admin)
    
    visit client_addresses_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Administrador não tem acesso a essa página'
  end
end
