require 'rails_helper'

describe 'Usuário edita um endereço' do
  context 'enquanto usuário autenticado' do
    it 'com sucesso' do
      user = create(:user)
      address = create(:address, city: 'Maruim', state: 'Sergipe', zipcode: '49770000')
      create(:client_address, user:, address:)

      login_as(user)
      visit client_addresses_path
      click_on 'Editar'
      fill_in 'Cidade', with: 'Curitiba'
      fill_in 'Estado', with: 'Paraná'
      fill_in 'CEP', with: '83439000'
      click_on 'Salvar'

      expect(page).to have_content 'Endereço editado com sucesso'
      expect(page).to have_content 'Curitiba'
      expect(page).to have_content 'Paraná'
      expect(page).to have_content '83439000'
      expect(page).not_to have_content 'Maruim'
      expect(page).not_to have_content 'Sergipe'
      expect(page).not_to have_content '49770000'
    end

    it 'com dados incompletos' do
      user = create(:user)
      address = create(:address, city: 'Maruim', state: 'Sergipe', zipcode: '49770000')
      create(:client_address, user:, address:)

      login_as(user)
      visit client_addresses_path
      click_on 'Editar'

      fill_in 'Endereço', with: ''
      fill_in 'Estado', with: ''
      fill_in 'CEP', with: '80000'
      click_on 'Salvar'

      expect(page).to have_content 'Endereço não pode ficar em branco'
      expect(page).to have_content 'Estado não pode ficar em branco'
      expect(page).to have_content 'CEP não possui o tamanho esperado (8 caracteres)'
      expect(page).to have_content 'Não foi possível editar o endereço, revise os campos abaixo:'
    end
  end
end
