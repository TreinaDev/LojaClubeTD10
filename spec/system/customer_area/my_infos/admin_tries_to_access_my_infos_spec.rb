require 'rails_helper'

describe 'Administrador tenta acessar minhas informações' do
  it 'e não consegue' do
    user = FactoryBot.create(:user, name: 'José', email: 'jose@punti.com', role: 1)

    login_as(user)
    visit user_path(user)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Administrador não tem acesso a essa página'
  end
end
