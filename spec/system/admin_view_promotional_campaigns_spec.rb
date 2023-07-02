require 'rails_helper'

describe 'Administrador acessa index de campanhas promocionais' do
  it 'e vê a lista de campanhas promocionais separadas de acordo com o seu andamento' do
    admin = create(:user, email: 'adm@punti.com')
    company = create(:company, brand_name: 'CodeCampus')

    travel_to 6.months.ago do
      create(:promotional_campaign, name: 'Verão 2023')
    end

    travel_to 1.month.ago do
      create(:promotional_campaign, name: 'Inverno 2023', end_date: 3.months.from_now.to_date)
    end

    create(:promotional_campaign, name: 'Outono 2023', company:)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'

    expect(page).to have_content 'Campanhas Promocionais'
    within '#campaigns_in_progress' do
      expect(page).to have_content 'Campanhas em andamento'
      expect(page).to have_content 'Inverno 2023'
    end
    within '#campaigns_future' do
      expect(page).to have_content 'Campanhas futuras'
      expect(page).to have_content 'Outono 2023'
    end
    within '#campaigns_finished' do
      expect(page).to have_content 'Campanhas finalizadas'
      expect(page).to have_content 'Verão 2023'
    end
  end

  it 'e não tem campanhas promocionais em andamento' do
    admin = create(:user, email: 'adm@punti.com')
    company = create(:company, brand_name: 'CodeCampus')
    travel_to 6.months.ago do
      create(:promotional_campaign, name: 'Verão 2023')
    end
    create(:promotional_campaign, name: 'Outono 2023', company:)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'

    expect(page).to have_content 'Campanhas Promocionais'
    within '#campaigns_in_progress' do
      expect(page).to have_content 'Campanhas em andamento'
      expect(page).to have_content 'Não existem Campanhas em andamento'
    end
    within '#campaigns_future' do
      expect(page).to have_content 'Campanhas futuras'
      expect(page).to have_content 'Outono 2023'
    end
    within '#campaigns_finished' do
      expect(page).to have_content 'Campanhas finalizadas'
      expect(page).to have_content 'Verão 2023'
    end
  end

  it 'e não tem campanhas promocionais futuras' do
    admin = create(:user, email: 'adm@punti.com')
    create(:company, brand_name: 'CodeCampus')
    travel_to 6.months.ago do
      create(:promotional_campaign, name: 'Verão 2023')
    end
    travel_to 1.month.ago do
      create(:promotional_campaign, name: 'Inverno 2023', end_date: 3.months.from_now.to_date)
    end

    login_as(admin)
    visit root_path
    click_on 'Campanhas'

    expect(page).to have_content 'Campanhas Promocionais'
    within '#campaigns_in_progress' do
      expect(page).to have_content 'Campanhas em andamento'
      expect(page).to have_content 'Inverno 2023'
    end
    within '#campaigns_future' do
      expect(page).to have_content 'Campanhas futuras'
      expect(page).to have_content 'Não existem Campanhas futuras'
    end
    within '#campaigns_finished' do
      expect(page).to have_content 'Campanhas finalizadas'
      expect(page).to have_content 'Verão 2023'
    end
  end

  it 'e não tem campanhas promocionais finalizadas' do
    admin = create(:user, email: 'adm@punti.com')
    company = create(:company, brand_name: 'CodeCampus')
    travel_to 1.month.ago do
      create(:promotional_campaign, name: 'Inverno 2023', end_date: 3.months.from_now.to_date)
    end
    create(:promotional_campaign, name: 'Outono 2023', company:)

    login_as(admin)
    visit root_path
    click_on 'Campanhas'

    expect(page).to have_content 'Campanhas Promocionais'
    within '#campaigns_in_progress' do
      expect(page).to have_content 'Campanhas em andamento'
      expect(page).to have_content 'Inverno 2023'
    end
    within '#campaigns_future' do
      expect(page).to have_content 'Campanhas futuras'
      expect(page).to have_content 'Outono 2023'
    end
    within '#campaigns_finished' do
      expect(page).to have_content 'Campanhas finalizadas'
      expect(page).to have_content 'Não existem Campanhas finalizadas'
    end
  end

  it 'e não tem campanhas promocionais cadastradas' do
    admin = create(:user, email: 'adm@punti.com')

    login_as(admin)
    visit promotional_campaigns_path

    expect(page).to have_content 'Campanhas Promocionais'
    expect(page).to have_content 'Não existem Campanhas Promocionais cadastradas'
  end

  it 'como visitante tenta acessar, mas é direcionado para logar' do
    visit root_path
    visit promotional_campaigns_path

    expect(current_path).to eq new_user_session_path
    expect(page).not_to have_content 'Campanhas Promocionais'
    expect(page).to have_content 'Você precisa fazer login ou se registrar antes de continuar'
  end

  it 'como usuário comum tenta acessar, mas não tem acesso e é direcionado para o root' do
    user = create(:user)

    login_as(user)
    visit root_path
    visit promotional_campaigns_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este módulo'
  end
end
