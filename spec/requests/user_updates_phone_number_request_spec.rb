require 'rails_helper'

describe 'Usuário atualiza o número de telefone' do
  it 'apenas estando autenticado' do
    post update_phone_number_path :params => { :phone_number => '19934568070' }

    expect(response).to redirect_to new_user_session_path
  end
end