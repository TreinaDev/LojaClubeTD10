require 'rails_helper'

describe 'Usuário registra preço sazonal' do
  it 'enquanto usuário comun' do
    user = create(:user)

    login_as user

    post seasonal_prices_path, params: {
      seasonal_price: { value: 100, start_date: 1.day.from_now, end_date: 7.days.from_now }
    }

    expect(response.status).to eq 302
    expect(flash[:alert]).to eq 'Você não possui acesso a este módulo'
    expect(response).to redirect_to root_path
  end

  it 'enquanto usuário não autenticado' do
    post seasonal_prices_path, params: {
      seasonal_price: { value: 100, start_date: 1.day.from_now, end_date: 7.days.from_now }
    }

    expect(response.status).to eq 302
    expect(flash[:alert]).to eq 'Você precisa fazer login ou se registrar antes de continuar'
    expect(response).to redirect_to new_user_session_path
  end
end
