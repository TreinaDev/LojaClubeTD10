require 'rails_helper'

describe 'Administrador desativa um produto' do
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
