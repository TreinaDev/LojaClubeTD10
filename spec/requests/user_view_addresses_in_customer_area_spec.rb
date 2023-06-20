require 'rails_helper'

describe 'Usuário vê seus endereços pela área do cliente' do
  it 'e adiministrador não tem acesso' do
    user = create(:user, email: 'admin@punti.com')

    login_as(user)
    get client_addresses_path

    follow_redirect!

    expect(request.path).to eq root_path
    expect(response.body).to include 'Administrador não tem acesso a essa página'
  end
end
