require 'rails_helper'

describe 'Administrador revome uma categoria e seu respectivo desconto para uma campanha promocional' do
  it 'a partir da tela de detalhes da campanha' do
    admin = create(:user, email: 'adm@punti.com')
    category2 = create(:product_category, name: 'Eletrônicos')
    promotional_campaign = create(:promotional_campaign, name: 'Natal 2023',
                                                         start_date: 1.week.from_now, end_date: 1.month.from_now)
    create(:campaign_category, promotional_campaign:)
    create(:campaign_category, product_category: category2, promotional_campaign:, discount: 20)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    click_on 'Natal 2023'
    find_button('Remover', id: 'campaign_category_1').click

    expect(page).to have_content 'Natal 2023'
    expect(current_path).to eq promotional_campaign_path(promotional_campaign.id)
    count_category_after = CampaignCategory.where(promotional_campaign:).count
    expect(count_category_after).to eq 1
    expect(page).to have_content 'Categoria/Desconto removidos com sucesso'
    expect(page).not_to have_content 'Celulares - 10% de desconto'
    expect(page).to have_content 'Eletrônicos - 20% de desconto'
  end

  it 'como visitante tenta acessar, mas é direcionado para logar' do
    promotional_campaign = create(:promotional_campaign)
    create(:campaign_category, promotional_campaign:)

    visit edit_promotional_campaign_path(promotional_campaign.id)

    expect(current_path).to eq new_user_session_path
    expect(page).not_to have_field('Nome')
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end

  it 'como usuário comum tenta acessar, mas não tem acesso e é direcionado para o root' do
    user = create(:user)
    promotional_campaign = create(:promotional_campaign)
    create(:campaign_category, promotional_campaign:)

    login_as(user)
    visit edit_promotional_campaign_path(promotional_campaign.id)

    expect(current_path).to eq root_path
    expect(page).not_to have_field('Nome')
    expect(page).to have_content 'Você não possui acesso a este módulo'
  end
end
