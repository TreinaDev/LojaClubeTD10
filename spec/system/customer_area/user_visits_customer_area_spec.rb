require 'rails_helper'

describe 'Usuário visita área do cliente' do
  it 'e não está logado' do
    visit customer_area_index_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end
  context 'estando logado' do
    it 'a partir de um link na barra de navegação' do
      user = FactoryBot.create(:user, name: 'José', email: 'jose@gmail.com', password: 'jose1234')

      login_as(user)
      visit root_path

      expect(page).to have_css 'i.bi.bi-person-circle'
      expect(page).to have_content 'Área do Cliente'
    end
    it 'e vê a área do cliente' do
      user = FactoryBot.create(:user, name: 'José', email: 'jose@gmail.com', password: 'jose1234', cpf: '60789974088',
                                      phone_number: '85999923132')

      login_as(user)
      visit root_path
      click_on 'Área do Cliente'

      expect(current_path).to eq customer_area_index_path
      expect(page).to have_content 'José'
      expect(page).to have_content 'jose@gmail.com'
      expect(page).to have_content 'Pedidos Recentes'
      expect(page).to have_link 'Meus Pedidos'
      expect(page).to have_link 'Endereços Cadastrados'
      expect(page).to have_link 'Minhas Informações'
      expect(page).to have_link 'Produtos Favoritos'
      expect(page).to have_link 'Minha Conta'
    end
  end
  it 'e sendo administrador não consegue' do
    user_admin = FactoryBot.create(:user, email: 'jose@punti.com')

    login_as(user_admin)
    visit customer_area_index_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Administrador não tem acesso a essa página'
  end
end
