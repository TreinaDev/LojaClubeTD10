require 'rails_helper'

describe 'Usuário atualiza o número de telefone' do
  it 'a partir do campo em minhas informações' do
    user = create(:user, phone_number: '19934567890')

    login_as(user)
    visit root_path
    click_on 'Área do Cliente'
    click_on 'Minhas Informações'

    expect(page).to have_field 'phone_number', with: '(19)93456-7890'
    expect(page).to have_button 'Atualizar Contato'
  end
  it 'com sucesso' do
    user = create(:user, phone_number: '19934567890')

    login_as(user)
    visit root_path
    click_on 'Área do Cliente'
    click_on 'Minhas Informações'
    fill_in 'phone_number',	with: '(19)93456-7823'
    click_on 'Atualizar Contato'

    expect(current_path).to eq me_path
    expect(page).to have_content 'Número de telefone atualizado com sucesso'
    expect(page).to have_field 'phone_number', with: '(19)93456-7823'
  end
  it 'sem sucesso, pois deixou número com 9 dígitos' do
    user = create(:user, phone_number: '19934567890')

    login_as(user)
    visit root_path
    click_on 'Área do Cliente'
    click_on 'Minhas Informações'
    fill_in 'phone_number',	with: '(19)93456-78'
    click_on 'Atualizar Contato'

    expect(current_path).to eq me_path
    expect(page).to have_content 'Erro: O número de telefone deve conter 11 dígitos'
    expect(page).not_to have_field 'phone_number', with: '(19)93456-78'
  end
  it 'sem sucesso, pois deixou o campo em branco' do
    user = create(:user, phone_number: '19934567890')

    login_as(user)
    visit root_path
    click_on 'Área do Cliente'
    click_on 'Minhas Informações'
    fill_in 'phone_number',	with: ''
    click_on 'Atualizar Contato'

    expect(current_path).to eq me_path
    expect(page).to have_content 'Erro: O número de telefone deve conter 11 dígitos'
    expect(page).not_to have_field 'phone_number', with: ''
  end
  it 'sem sucesso, pois usou letras no campo' do
    user = create(:user, phone_number: '19934567890')

    login_as(user)
    visit root_path
    click_on 'Área do Cliente'
    click_on 'Minhas Informações'
    fill_in 'phone_number',	with: 'abx123'
    click_on 'Atualizar Contato'

    expect(current_path).to eq me_path
    expect(page).to have_content 'Erro: O número de telefone deve conter 11 dígitos'
    expect(page).not_to have_field 'phone_number', with: 'abx123'
  end
end
