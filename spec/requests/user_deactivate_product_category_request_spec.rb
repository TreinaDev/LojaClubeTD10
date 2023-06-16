require 'rails_helper'

describe 'Usuário muda o status uma categoria' do
  context 'enquanto admin' do
    it 'e desativa uma categoria com sucesso' do
      admin = create(:user, email: 'admin@punti.com')
      category = create(:product_category, active: true)

      login_as(admin)
      patch deactivate_product_category_path(category)

      expect(response).to have_http_status :found
      expect(response).to redirect_to product_categories_path
      expect(category.reload.active).to eq false
    end

    it 'e reativa uma categoria com sucesso' do
      admin = create(:user, email: 'admin@punti.com')
      category = create(:product_category, active: false)

      login_as(admin)
      patch reactivate_product_category_path(category)

      expect(response).to have_http_status :found
      expect(response).to redirect_to product_categories_path
      expect(category.reload.active).to eq true
    end
  end

  context 'enquanto usuário autenticado' do
    it 'e tenta desativar, mas falha devido à falta de autorização' do
      user = create(:user, email: 'user@email.com')
      category = create(:product_category, active: true)

      login_as(user)
      patch deactivate_product_category_path(category)

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não possui acesso a este módulo'
      expect(category.reload.active).to eq true
    end

    it 'e tenta reativar, mas falha devido à falta de autorização' do
      user = create(:user, email: 'user@email.com')
      category = create(:product_category, active: false)

      login_as(user)
      patch reactivate_product_category_path(category)

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não possui acesso a este módulo'
      expect(category.reload.active).to eq false
    end
  end

  context 'enquanto visitante' do
    it 'e tenta desativar, mas falha devido à falta de autorização e autentificação' do
      category = create(:product_category, active: true)

      patch deactivate_product_category_path(category)

      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq 'Você precisa fazer login ou se registrar antes de continuar'
      expect(category.reload.active).to eq true
    end

    it 'e tenta reativar, mas falha devido à falta de autorização e autentificação' do
      category = create(:product_category, active: false)

      patch reactivate_product_category_path(category)

      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq 'Você precisa fazer login ou se registrar antes de continuar'
      expect(category.reload.active).to eq false
    end
  end
end
