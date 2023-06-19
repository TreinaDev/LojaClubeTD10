require 'rails_helper'

describe 'Administrador adiciona uma categoria e seu respectivo desconto para uma campanha promocional' do
  it 'a partir da tela de detalhes da campanha' do
    admin = create(:user, email: 'adm@punti.com')
    create(:product_category, name: 'Celulares')
    create(:product_category, name: 'Eletrônicos')
    promotional_campaign = create(:promotional_campaign, name: 'Natal 2023', start_date: 1.week.from_now,
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
    within '#form_campaign_category' do
      expect(page).not_to have_select('campaign_category[product_category_id]', with_options: ['Eletrônicos'])
    end
  end

  it 'com dados incompletos' do
    admin = create(:user, email: 'adm@punti.com')
    create(:product_category, name: 'Celulares')
    create(:product_category, name: 'Eletrônicos')
    create(:promotional_campaign, name: 'Natal 2023', start_date: 1.week.from_now,
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

  it 'e não vê uma categoria desativada' do
    admin = create(:user, email: 'adm@punti.com')
    create(:product_category, name: 'Celulares', active: false)
    create(:promotional_campaign)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    click_on 'Natal 2023'

    within '#form_campaign_category' do
      expect(page).not_to have_select('campaign_category[product_category_id]', with_options: ['Celulares'])
    end
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
