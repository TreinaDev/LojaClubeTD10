require 'rails_helper'

describe 'Administrador revome uma categoria e seu respectivo desconto para uma campanha promocional' do
  it 'a partir da tela de detalhes da campanha' do
    admin = create(:user, email: 'adm@punti.com')
    category1 = create(:product_category, name: 'Celulares')
    category2 = create(:product_category, name: 'Eletrônicos')
    company = create(:company)
    promotional_campaign = create(:promotional_campaign, name: 'Natal 2023', company:, start_date: 1.week.from_now,
                                                         end_date: 1.month.from_now)
    CampaignCategory.create!(promotional_campaign:, product_category: category1, discount: 10)
    CampaignCategory.create!(promotional_campaign:, product_category: category2, discount: 20)

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
end
