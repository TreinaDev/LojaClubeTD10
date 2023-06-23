require 'rails_helper'

describe 'Administrador desativa produto' do
  context 'individualmente' do
    it 'com sucesso' do
      admin = create(:user, email: 'admin@punti.com')
      product = create(:product)

      login_as(admin)
      visit products_path
      find_button('Desativar', id: "#{product.id}_deactivate").click
      product.reload

      expect(page).to have_selector(:link_or_button, 'Reativar', id: "#{product.id}_reactivate")
      expect(page).not_to have_selector(:link_or_button, 'Desativar', id: "#{product.id}_deactivate")
      expect(page).to have_content 'Produto desativado com sucesso'
      expect(current_path).to eq products_path
      expect(product.active).to eq false
    end

    it 'e reativa um produto com sucesso' do
      admin = create(:user, email: 'admin@punti.com')
      product = create(:product)

      login_as(admin)
      visit products_path
      find_button('Desativar', id: "#{product.id}_deactivate").click
      product.reload
      find_button('Reativar', id: "#{product.id}_reactivate").click
      product.reload

      expect(page).not_to have_selector(:link_or_button, 'Reativar', id: "#{product.id}_reactivate")
      expect(page).to have_selector(:link_or_button, 'Desativar', id: "#{product.id}_deactivate")
      expect(page).to have_content 'Produto reativado com sucesso'
      expect(current_path).to eq products_path
      expect(product.active).to eq true
    end
  end

  context 'em grupo' do
    it 'e vê mensagem de confirmação ao desativar todos' do
      admin = create(:user, email: 'admin@punti.com')
      create(:product, name: 'TV LG')
      create(:product, code: 'ASD456789', name: 'TV Samsung')
      create(:product, code: 'CVB987675', name: 'Celular Motorola')

      login_as(admin)
      visit products_path
      fill_in 'query_products', with: 'TV'
      within('.input-group') do
        click_on 'Filtrar'
      end
      click_on 'Desativar todos'

      expect(page).to have_content 'Você tem certeza disso?'
    end

    it 'e vê mensagem de confirmação ao reativar todos' do
      admin = create(:user, email: 'admin@punti.com')
      create(:product, name: 'TV LG', active: false)
      create(:product, code: 'ASD456789', name: 'TV Samsung', active: false)
      create(:product, code: 'CVB987675', name: 'Celular Motorola')

      login_as(admin)
      visit products_path
      fill_in 'query_products', with: 'TV'
      within('.input-group') do
        click_on 'Filtrar'
      end
      click_on 'Reativar todos'

      expect(page).to have_content 'Você tem certeza disso?'
    end

    it 'após resultado da busca' do
      admin = create(:user, email: 'admin@punti.com')
      product_a = create(:product, name: 'TV LG')
      product_b = create(:product, code: 'ASD456789', name: 'TV Samsung')
      create(:product, code: 'CVB987675', name: 'Celular Motorola')

      login_as(admin)
      visit products_path
      fill_in 'query_products', with: 'TV'
      within('.input-group') do
        click_on 'Filtrar'
      end
      click_on 'Desativar todos'
      within('.final-dea') do
        click_on 'Desativar'
      end

      expect(page).not_to have_content 'Celular Motorola'
      expect(page).to have_content 'TV LG'
      expect(page).to have_content 'TV Samsung'
      expect(page).to have_selector(:link_or_button, 'Reativar', id: "#{product_a.id}_reactivate")
      expect(page).to have_selector(:link_or_button, 'Reativar', id: "#{product_b.id}_reactivate")
      expect(page).not_to have_selector(:link_or_button, 'Desativar', id: "#{product_a.id}_deactivate")
      expect(page).not_to have_selector(:link_or_button, 'Desativar', id: "#{product_b.id}_deactivate")
    end
  end
end
