require 'rails_helper'

describe 'Usuário acessa rota de favorito de um produto' do
  context 'enquanto cliente autenticado' do
    it 'e marca produto como favorito com sucesso' do
      user = create(:user, email: 'ricardo@exemple.com')
      cat = create(:product_category, name: 'Categoria teste')
      product = create(:product, product_category_id: cat.id)

      login_as user
      post favorites_path, params: { favorite: { user_id: user.id, product_id: product.id } }

      expect(response).to have_http_status :found
      expect(response).to redirect_to product_path(product)
    end

    it 'e desmarca um produto dos favoritos com sucesso' do
      user = create(:user, email: 'ricardo@exemple.com')
      cat = create(:product_category, name: 'Categoria teste')
      product = create(:product, product_category_id: cat.id)

      login_as user
      post favorites_path, params: { favorite: { user_id: user.id, product_id: product.id } }
      delete favorite_path(product)

      expect(response).to have_http_status :found
      expect(response).to redirect_to product_path(product)
    end
  end

  # context 'enquanto admin' do
  #   it 'e tenta selecionar um favorito mas falha devido à falta de autorização' do
  #     admin = create(:user, email: 'ricardo@punti.com')
  #     cat = create(:product_category, name: 'Categoria teste')
  #     product = create(:product, product_category_id: cat.id)

  #     login_as admin
  #     post favorites_path, params: { favorite: { user_id: admin.id, product_id: product.id } }

  #     expect(response).to have_http_status 302
  #     expect(flash[:alert]).to eq 'Apenas clientes podem marcar produtos favoritos'
  #     expect(response).to redirect_to product_path(product)
  #   end
  # end
end
