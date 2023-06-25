require 'rails_helper'

describe 'Usuário vê preços sazonais' do
  it 'como usuário comum' do
    user = create(:user)

    login_as user

    get seasonal_prices_path

    expect(response.status).to eq 302
    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq 'Você não possui acesso a este módulo'
  end

  it 'como usuário não autenticado' do
    get seasonal_prices_path

    expect(response.status).to eq 302
    expect(response).to redirect_to new_user_session_path
    expect(flash[:alert]).to eq 'Você precisa fazer login ou se registrar antes de continuar'
  end

  context 'e não consegue apagar um preço sazonal' do
    it 'como usuário comum' do
      user = create(:user)
      seasonal_price = create(:seasonal_price)

      login_as user

      delete seasonal_price_path(seasonal_price)

      expect(response.status).to eq 302
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não possui acesso a este módulo'
    end

    it 'como usuário não autenticado' do
      seasonal_price = create(:seasonal_price)

      delete seasonal_price_path(seasonal_price)

      expect(response.status).to eq 302
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq 'Você precisa fazer login ou se registrar antes de continuar'
    end
  end
end
