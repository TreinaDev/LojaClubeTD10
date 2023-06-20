require 'rails_helper'

describe 'Usuário edita uma campanha promocional' do
  context 'enquanto admin' do
    it 'com sucesso' do
      admin = create(:user, email: 'admin@punti.com')
      promotional_campaign = create(:promotional_campaign)

      login_as(admin)
      patch(promotional_campaign_path(promotional_campaign.id),
            params: { promotional_campaign: { name: 'Natal' } })

      expect(response).to have_http_status :found
      expect(response).to redirect_to promotional_campaign_path(promotional_campaign.id)
    end
  end

  context 'enquanto visitante' do
    it 'mas não está logado e é direcionado para o login' do
      promotional_campaign = create(:promotional_campaign)

      patch(promotional_campaign_path(promotional_campaign.id),
            params: { promotional_campaign: { name: 'Natal' } })

      expect(response).to have_http_status :found
      expect(response).to redirect_to new_user_session_path
    end
  end

  context 'enquanto usuário comum' do
    it 'mas não tem acesso e é direcionado para o root' do
      user = create(:user)
      promotional_campaign = create(:promotional_campaign)

      login_as(user)
      patch(promotional_campaign_path(promotional_campaign.id),
            params: { promotional_campaign: { name: 'Natal' } })

      expect(response).to have_http_status :found
      expect(response).to redirect_to root_path
    end
  end
end
