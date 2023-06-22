require 'rails_helper'

describe 'Usuário desativa produto' do
  context 'enquanto admin - individualmente' do
    it 'com sucesso' do
      admin = create(:user, email: 'admin@punti.com')
      product = create(:product)

      login_as(admin)
      patch deactivate_product_path(product)

      expect(response).to have_http_status :found
      expect(response).to redirect_to products_path
      expect(product.reload.active).to eq false
    end

    it 'e reativa o produto com sucesso' do
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
  end

  context 'Enquanto admin - em grupo' do
    it 'com sucesso' do
      admin = create(:user, email: 'admin@punti.com')
      product_a = create(:product, name: 'TV LG')
      product_b = create(:product, code: 'ASD456789', name: 'TV Samsung')
      create(:product, code: 'CVB987675', name: 'Celular Motorola')

      login_as(admin)
      patch deactivate_all_products_path(query_products: 'TV')

      expect(response).to have_http_status :found
      expect(response).to redirect_to products_path(query_products: 'TV')
      expect(product_a.reload.active).to eq false
      expect(product_b.reload.active).to eq false
    end

    it 'e reativa um grupo com sucesso' do
      admin = create(:user, email: 'admin@punti.com')
      product_a = create(:product, name: 'TV LG', active: false)
      product_b = create(:product, code: 'ASD456789', name: 'TV Samsung', active: false)
      create(:product, code: 'CVB987675', name: 'Celular Motorola')

      login_as(admin)
      patch reactivate_all_products_path(query_products: 'TV')

      expect(response).to have_http_status :found
      expect(response).to redirect_to products_path(query_products: 'TV')
      expect(product_a.reload.active).to eq true
      expect(product_b.reload.active).to eq true
    end
  end

  context 'enquanto usuário autenticado - individualmente' do
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

  context 'enquanto usuário autenticado - em grupo' do
    it 'e tenta desativar, mas falha devido à falta de autorização' do
      user = create(:user)
      product_a = create(:product, name: 'TV LG')
      product_b = create(:product, code: 'ASD456789', name: 'TV Samsung')

      login_as(user)
      patch deactivate_all_products_path(query_products: 'TV')

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não possui acesso a este módulo'
      expect(product_a.reload.active).to eq true
      expect(product_b.reload.active).to eq true
    end

    it 'e tenta resativar, mas falha devido à falta de autorização' do
      user = create(:user)
      product_a = create(:product, name: 'TV LG', active: false)
      product_b = create(:product, code: 'ASD456789', name: 'TV Samsung', active: false)

      login_as(user)
      patch reactivate_all_products_path(query_products: 'TV')

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não possui acesso a este módulo'
      expect(product_a.reload.active).to eq false
      expect(product_b.reload.active).to eq false
    end
  end

  context 'enquanto visitante  - individualmente' do
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

  context 'enquanto visitante  - em grupo' do
    it 'e tenta desativar, mas falha devido à falta de autorização e autentificação' do
      product_a = create(:product, name: 'TV LG')
      product_b = create(:product, code: 'ASD456789', name: 'TV Samsung')

      patch deactivate_all_products_path('TV')

      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq 'Faça login para acessar'
      expect(product_a.reload.active).to eq true
      expect(product_b.reload.active).to eq true
    end

    it 'e tenta reativar, mas falha devido à falta de autorização e autentificação' do
      product_a = create(:product, name: 'TV LG', active: false)
      product_b = create(:product, code: 'ASD456789', name: 'TV Samsung', active: false)

      patch reactivate_all_products_path('TV')

      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq 'Faça login para acessar'
      expect(product_a.reload.active).to eq false
      expect(product_b.reload.active).to eq false
    end
  end
end
