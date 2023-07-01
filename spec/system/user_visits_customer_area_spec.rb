require 'rails_helper'

describe 'Usuário visita área do cliente' do
  it 'e não está logado' do
    visit customer_areas_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end
  context 'estando logado' do
    it 'a partir de um link na barra de navegação' do
      user = create(:user, name: 'José', email: 'jose@gmail.com', password: 'jose1234')

      login_as(user)
      visit root_path

      expect(page).to have_css 'i.bi.bi-person-circle'
      expect(page).to have_content 'Área do Cliente'
    end
    it 'e vê a área do cliente' do
      user = create(:user, name: 'José', email: 'jose@gmail.com', password: 'jose1234', cpf: '60789974088',
                           phone_number: '85999923132')

      login_as(user)
      visit root_path
      click_on 'Área do Cliente'

      expect(current_path).to eq customer_areas_path
      expect(page).to have_content 'José'
      expect(page).to have_content 'jose@gmail.com'
      expect(page).to have_link 'Meus Pedidos'
      expect(page).to have_link 'Meus Endereços'
      expect(page).to have_link 'Minhas Informações'
      expect(page).to have_link 'Meus Favoritos'
      expect(page).to have_link 'Minha Conta'
    end
    it 'e vê o endereço padrão' do
      user = create(:user)
      default_address = create(:address, address: 'Rua Aquidabã', number: '115',
                                         city: 'Aracaju', state: 'Sergipe', zipcode: '48005000')
      ClientAddress.create!(user:, address: default_address, default: true)
      address = create(:address, address: 'Rua Lima', number: '200',
                                 city: 'Santos', state: 'Sao Paulo', zipcode: '65005000')
      ClientAddress.create!(user:, address:)

      login_as(user)
      visit root_path
      click_on 'Área do Cliente'

      expect(current_path).to eq customer_areas_path
      expect(page).to have_content 'Endereço Principal'
      expect(page).to have_content 'Rua Aquidabã'
      expect(page).to have_content '115'
      expect(page).to have_content 'Meus Pedidos'
      expect(page).to have_content 'Aracaju'
      expect(page).to have_content 'Sergipe'
      expect(page).to have_content 'CEP: 4800500'
      expect(page).not_to have_content 'Rua Lima'
      expect(page).not_to have_content '200'
      expect(page).not_to have_content 'Santos'
      expect(page).not_to have_content 'São Paulo'
      expect(page).not_to have_content '65005000'
    end
    it 'e vê mensagem, caso não tenha endereço padrão' do
      user = create(:user)

      login_as(user)
      visit root_path
      click_on 'Área do Cliente'

      expect(current_path).to eq customer_areas_path
      expect(page).to have_content 'Endereço Principal'
      expect(page).to have_content 'Não possui endereço cadastrado como padrão!'
    end
  end
  it 'e sendo administrador não consegue' do
    user_admin = create(:user, email: 'jose@punti.com')

    login_as(user_admin)
    visit customer_areas_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Administrador não tem acesso a essa página'
  end
end
