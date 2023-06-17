require 'rails_helper'

describe 'Usuário remove uma categoria de uma campanha promocional' do
  context 'enquanto admin' do
    it 'com sucesso' do
      admin = create(:user, email: 'adm@punti.com')
      category1 = create(:product_category, name: 'Celulares')
      category2 = create(:product_category, name: 'Eletrônicos')
      company = create(:company)
      promotional_campaign = create(:promotional_campaign, name: 'Natal 2023', company:, start_date: 1.week.from_now,
                                                           end_date: 1.month.from_now)
      campaign_category = CampaignCategory.create!(promotional_campaign:, product_category: category1,
                                                   discount: 10)
      CampaignCategory.create!(promotional_campaign:, product_category: category2, discount: 20)

      login_as(admin)
      delete(promotional_campaign_campaign_category_path(promotional_campaign.id, campaign_category.id))

      expect(response).to have_http_status :found
      expect(response).to redirect_to promotional_campaign_path(promotional_campaign.id)
    end
  end

  context 'enquanto visitante' do
    it 'mas não está logado e é direcionado para o login' do
      category1 = create(:product_category, name: 'Celulares')
      company = create(:company)
      promotional_campaign = create(:promotional_campaign, name: 'Natal 2023', company:,
                                                           start_date: 1.week.from_now, end_date: 1.month.from_now)
      campaign_category = CampaignCategory.create!(promotional_campaign:, product_category: category1,
                                                   discount: 10)

      delete(promotional_campaign_campaign_category_path(promotional_campaign.id, campaign_category.id))

      expect(response).to have_http_status :found
      expect(response).to redirect_to new_user_session_path
    end
  end

  context 'enquanto usuário comum' do
    it 'mas não tem acesso e é direcionado para o root' do
      user = create(:user)
      category1 = create(:product_category, name: 'Celulares')
      company = create(:company)
      promotional_campaign = create(:promotional_campaign, name: 'Natal 2023', company:,
                                                           start_date: 1.week.from_now, end_date: 1.month.from_now)
      campaign_category = CampaignCategory.create!(promotional_campaign:, product_category: category1,
                                                   discount: 10)

      login_as(user)
      delete(promotional_campaign_campaign_category_path(promotional_campaign.id, campaign_category.id))

      expect(response).to have_http_status :found
      expect(response).to redirect_to root_path
    end
  end
end
