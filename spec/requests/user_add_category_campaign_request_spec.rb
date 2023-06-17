require 'rails_helper'

describe 'Administrador adiciona uma categoria e seu respectivo desconto para uma campanha promocional' do
  context 'enquanto admin' do
    it 'com sucesso' do
      admin = create(:user, email: 'admin@punti.com')
      category = create(:product_category)
      company = create(:company)
      promotional_campaign = create(:promotional_campaign, company:)

      login_as(admin)
      post promotional_campaign_campaign_categories_path(promotional_campaign.id),
           params: { campaign_category: { product_category_id: category.id, discount: 10 } }

      expect(response).to have_http_status :found
      expect(response).to redirect_to promotional_campaign_path(promotional_campaign.id)
    end
  end

  context 'enquanto visitante' do
    it 'mas não está logado e é direcionado para o login' do
      category = create(:product_category)
      company = create(:company)
      promotional_campaign = create(:promotional_campaign, company:)

      post promotional_campaign_campaign_categories_path(promotional_campaign.id),
           params: { campaign_category: { product_category_id: category.id, discount: 10 } }

      expect(response).to have_http_status :found
      expect(response).to redirect_to new_user_session_path
    end
  end

  context 'enquanto usuário comum' do
    it 'mas não tem acesso e é direcionado para o root' do
      user = create(:user)
      category = create(:product_category)
      company = create(:company)
      promotional_campaign = create(:promotional_campaign, company:)

      login_as(user)
      post promotional_campaign_campaign_categories_path(promotional_campaign.id),
           params: { campaign_category: { product_category_id: category.id, discount: 10 } }

      expect(response).to have_http_status :found
      expect(response).to redirect_to root_path
    end
  end
end
