require 'rails_helper'

describe 'Usuário edita preço sazonal' do
  it 'enquanto usuário comum' do
    user = create(:user)
    seasonal_price = create(:seasonal_price)

    login_as user
    patch seasonal_price_path(seasonal_price), params: { seasonal_price: { value: seasonal_price.value - 1 } }

    expect(response.status).to eq 302
    expect(flash[:alert]).to eq 'Você não possui acesso a este módulo'
  end

  it 'enquanto não autenticado' do
    seasonal_price = create(:seasonal_price)

    patch seasonal_price_path(seasonal_price), params: { seasonal_price: { value: seasonal_price.value - 1 } }

    expect(response.status).to eq 302
    expect(flash[:alert]).to eq 'Você precisa fazer login ou se registrar antes de continuar'
  end
end
