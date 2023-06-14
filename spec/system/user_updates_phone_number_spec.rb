require 'rails_helper'

describe 'Usuário atualiza o número de telefone' do
  it 'a partir de do campo em minhas informações' do
    user = FactoryBot.create(:user, phone_number: '19934567890')

    login_as(user)
    visit root_path
    click_on 'Área do Cliente'
    click_on 'Minhas Informações'

    expect(page).to have_field 'phone_number', with: '(19)93456-7890'
    expect(page).to have_button 'Atualizar Contato'
  end
end
