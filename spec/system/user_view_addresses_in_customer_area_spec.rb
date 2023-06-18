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
end
