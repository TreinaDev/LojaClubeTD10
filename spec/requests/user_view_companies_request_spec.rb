require 'rails_helper'

describe 'Usuário vê lista de empresas' do
  it 'como usuário comum' do
    user = create(:user)

    login_as user

    get companies_path

    expect(response.status).to eq 302
    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq 'Você não possui acesso a este módulo'
  end

  it 'como usuário não autenticado' do
    get companies_path

    expect(response.status).to eq 302
    expect(response).to redirect_to new_user_session_path
    expect(flash[:alert]).to eq 'Você precisa fazer login ou se registrar antes de continuar'
  end
end
