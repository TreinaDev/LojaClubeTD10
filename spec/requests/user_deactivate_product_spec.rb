require 'rails_helper'

describe 'Usuário acessa rota de desativar produto' do
  context 'Enquanto admin' do
    it 'e desativa um produto com sucesso' do
      admin = create(:user, email: 'admin@punti.com')
      product = create(:product)

      login_as(admin)
      patch deactivate_product_path(product)

      expect(response).to have_http_status :found
      expect(response).to redirect_to products_path
      expect(product.reload.active).to eq false
    end
  end

  it 'e reativa um produto com sucesso' do
    admin = create(:user, email: 'admin@punti.com')
    product = create(:product)

    login_as(admin)
    patch deactivate_product_path(product)
    product.reload
    patch reactivate_product_path(product)

    expect(response).to have_http_status :found
    expect(response).to redirect_to products_path
    expect(product.reload.active).to eq true
  end

  context 'enquanto usuário autenticado' do
    it 'e tenta desativar, mas falha devido à falta de autorização' do
      user = create(:user)
      product = create(:product)

      login_as(user)
      patch deactivate_product_path(product)

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não possui acesso a este módulo'
      expect(product.reload.active).to eq true
    end

    it 'e tenta reativar, mas falha devido à falta de autorização' do
      user = create(:user)
      product = create(:product, active: false)

      login_as(user)
      patch reactivate_product_path(product)

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não possui acesso a este módulo'
      expect(product.reload.active).to eq false
    end
  end

  context 'enquanto visitante' do
    it 'e tenta desativar, mas falha devido à falta de autorização e autentificação' do
      product = create(:product)

      patch deactivate_product_path(product)

      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq 'Faça login para acessar'
      expect(product.reload.active).to eq true
    end

    it 'e tenta reativar, mas falha devido à falta de autorização e autentificação' do
      product = create(:product, active: false)

      patch reactivate_product_path(product)

      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq 'Faça login para acessar'
      expect(product.reload.active).to eq false
    end
  end
end
