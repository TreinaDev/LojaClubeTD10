require 'rails_helper'

describe 'Administrador adiciona uma categoria e seu respectivo desconto para uma campanha promocional' do
  it 'com sucesso, para uma campanha futura' do
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

  it 'e não visualiza as categorias adicionadas à uma campanha da mesma empresa, com período sobrepostos' do
    admin = create(:user, email: 'adm@punti.com')
    category1 = create(:product_category, name: 'Celulares')
    category2 = create(:product_category, name: 'Eletrônicos')
    create(:product_category, name: 'TV')
    company_a = create(:company, brand_name: 'Empresa A')
    promotional_campaign_a = create(:promotional_campaign, name: 'Campanha 1 da Empresa A', company: company_a,
                                                           start_date: 2.days.from_now, end_date: 4.weeks.from_now)
    create(:campaign_category, promotional_campaign: promotional_campaign_a, product_category: category1, discount: 10)
    create(:campaign_category, promotional_campaign: promotional_campaign_a, product_category: category2, discount: 20)

    create(:promotional_campaign, name: 'Campanha 2 da Empresa A', company: company_a,
                                  start_date: 1.week.from_now, end_date: 2.weeks.from_now)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    click_on 'Campanha 2 da Empresa A'

    expect(page).to have_content 'Campanha 2 da Empresa A'
    within '#form_campaign_category' do
      expect(page).to have_content 'Adicionar Categorias à Campanha'
      expect(page).to have_select 'Categoria', with_options: ['TV']
      expect(page).not_to have_select('campaign_category[product_category_id]', with_options: %w[Eletrônicos Celulares])
      expect(page).to have_field('Desconto')
      expect(page).to have_button('Cadastrar')
    end
  end

  it 'e não visualiza os campos do formulário pois a campanha está em andamento' do
    admin = create(:user, email: 'adm@punti.com')
    create(:product_category, name: 'Celulares')
    create(:product_category, name: 'Eletrônicos')
    travel_to 1.week.ago do
      create(:promotional_campaign, name: 'Natal 2023')
    end

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    click_on 'Natal 2023'

    expect(page).to have_content 'Natal 2023'
    within '#form_campaign_category' do
      expect(page).to have_content 'Adicionar Categorias à Campanha'
      expect(page).not_to have_select('Categoria')
      expect(page).not_to have_field('Desconto')
      expect(page).not_to have_button('Cadastrar')
      expect(page).to have_content 'Não é possível mais adicionar ou remover categorias'
    end
  end

  it 'e não visualiza os campos do formulário pois a campanha está finalizada' do
    admin = create(:user, email: 'adm@punti.com')
    create(:product_category, name: 'Celulares')
    create(:product_category, name: 'Eletrônicos')
    travel_to 6.months.ago do
      create(:promotional_campaign, name: 'Natal 2023')
    end

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    click_on 'Natal 2023'

    expect(page).to have_content 'Natal 2023'
    within '#form_campaign_category' do
      expect(page).to have_content 'Adicionar Categorias à Campanha'
      expect(page).not_to have_select('Categoria')
      expect(page).not_to have_field('Desconto')
      expect(page).not_to have_button('Cadastrar')
      expect(page).to have_content 'Não é possível mais adicionar ou remover categorias'
    end
  end

  it 'e não visualiza os campos do formulário pois não há mais categorias disponíveis' do
    admin = create(:user, email: 'adm@punti.com')
    category1 = create(:product_category, name: 'Celulares')
    category2 = create(:product_category, name: 'Eletrônicos')
    promotional_campaign_a = create(:promotional_campaign, name: 'Natal 2023')
    create(:campaign_category, promotional_campaign: promotional_campaign_a, product_category: category1, discount: 10)
    create(:campaign_category, promotional_campaign: promotional_campaign_a, product_category: category2, discount: 20)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'
    click_on 'Natal 2023'

    expect(page).to have_content 'Natal 2023'
    within '#form_campaign_category' do
      expect(page).to have_content 'Adicionar Categorias à Campanha'
      expect(page).not_to have_select('Categoria')
      expect(page).not_to have_field('Desconto')
      expect(page).not_to have_button('Cadastrar')
      expect(page).to have_content 'Não há mais categorias disponíveis a serem adicionadas à campanha'
    end
  end
end
