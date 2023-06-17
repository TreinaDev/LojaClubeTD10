require 'rails_helper'

describe 'Usuário cadastra um campanha promocional' do
  context 'enquanto admin' do
    it 'com sucesso' do
      admin = create(:user, email: 'admin@punti.com')
      company = create(:company)

      login_as(admin)
      post(promotional_campaigns_path,
           params: { promotional_campaign: { name: 'Natal', start_date: 1.week.from_now, end_date: 1.month.from_now,
                                             company_id: company.id } })

      expect(response).to have_http_status :found
      expect(response).to redirect_to promotional_campaigns_path
    end
  end

  context 'enquanto visitante' do
    it 'mas não está logado e é direcionado para o login' do
      company = create(:company)

      post(promotional_campaigns_path,
           params: { promotional_campaign: { name: 'Natal', start_date: 1.week.from_now, end_date: 1.month.from_now,
                                             company_id: company.id } })

      expect(response).to have_http_status :found
      expect(response).to redirect_to new_user_session_path
    end
  end

  context 'enquanto usuário comum' do
    it 'mas não tem acesso e é direcionado para o root' do
      user = create(:user)
      company = create(:company)

      login_as(user)
      post(promotional_campaigns_path,
           params: { promotional_campaign: { name: 'Natal', start_date: 1.week.from_now, end_date: 1.month.from_now,
                                             company_id: company.id } })

      expect(response).to have_http_status :found
      expect(response).to redirect_to root_path
    end
  end
end
