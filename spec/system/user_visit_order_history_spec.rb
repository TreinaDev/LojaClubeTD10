require 'rails_helper'

describe 'Usuário acessa histórico de pedidos' do
  it 'a partir da área do cliente' do
    user = create(:user)
    login_as user

    visit customer_areas_path
    click_on 'Meus Pedidos'

    expect(current_path).to eq order_history_path
  end
end
