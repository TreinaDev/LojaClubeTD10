require 'rails_helper'

describe 'Administrador adiciona uma categoria e seu respectivo desconto para uma campanha promocional' do
  it 'a partir da tela de detalhes da campanha' do
    admin = create(:user, email: 'adm@punti.com')
    create(:product_category, name: 'Celulares')
    create(:product_category, name: 'Eletrônicos')
    company = create(:company)
    promotional_campaign = create(:promotional_campaign, name: 'Natal 2023', company:, start_date: 1.week.from_now,
                                                         end_date: 1.month.from_now)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    click_on 'Natal 2023'
    select 'Eletrônicos', from: 'Categoria'
    fill_in 'Desconto', with: '10'
    click_on 'Cadastrar'

    expect(page).to have_content 'Natal 2023'
    expect(current_path).to eq promotional_campaign_path(promotional_campaign.id)
    expect(page).to have_content 'Categoria/Desconto cadastrados com sucesso'
    expect(page).to have_content 'Eletrônicos - 10% de desconto'
  end

  it 'com dados incompletos' do
    admin = create(:user, email: 'adm@punti.com')
    create(:product_category, name: 'Celulares')
    create(:product_category, name: 'Eletrônicos')
    company = create(:company)
    create(:promotional_campaign, name: 'Natal 2023', company:, start_date: 1.week.from_now,
                                  end_date: 1.month.from_now)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    click_on 'Natal 2023'
    fill_in 'Desconto', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content 'Não foi possível cadastrar Categoria/Desconto à Campanha'
    expect(page).to have_content 'Desconto não pode ficar em branco'
    expect(page).not_to have_content 'Desconto cadastrados com sucesso'
  end
end
