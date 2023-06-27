require 'rails_helper'

describe 'Usuário vê preços com desconto' do
  it 'enquanto funcionário ativo e com cartão ativo, vê campanha apenas de sua empresa' do
    user = create(:user, cpf: '30450562026', email: 'zezinho@gmail.com', password: 'senha1234')
    card_json_data = Rails.root.join('spec/support/json/card_data_active.json').read
    card_fake_response = double('faraday_response', status: 200, body: card_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(card_fake_response)
    company_json_data = Rails.root.join('spec/support/json/cpf_active_company.json').read
    company_fake_response = double('faraday_response', status: 200, body: company_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:3000/api/v1/employee_profiles?cpf=#{user.cpf}").and_return(company_fake_response)
    category1 = create(:product_category, name: 'Celulares')
    category2 = create(:product_category, name: 'Eletrônicos')
    create(:product, product_category: category1, code: 'XYZ123456', name: 'Celular Azul', price: 1000)
    create(:product, product_category: category2, code: 'ABC123456', name: 'Celular Branco', price: 2000)
    company1 = create(:company, brand_name: 'Campus Code', registration_number: '12345678000195')
    company2 = create(:company, brand_name: 'Rebase', registration_number: '16190133000108')
    promotionalcampaign1 = create(:promotional_campaign, name: 'Natal 2023', start_date: 1.week.from_now,
                                                         end_date: 1.month.from_now, company: company1)
    promotionalcampaign2 = create(:promotional_campaign, name: 'Ano Novo 2023', start_date: 1.week.from_now,
                                                         end_date: 1.month.from_now, company: company2)
    create(:campaign_category, promotional_campaign: promotionalcampaign1, product_category: category1, discount: 10)
    create(:campaign_category, promotional_campaign: promotionalcampaign2, product_category: category2, discount: 20)

    visit root_path
    click_on 'Entrar'
    within 'form#new_user' do
      fill_in 'E-mail', with: 'zezinho@gmail.com'
      fill_in 'Senha', with: 'senha1234'
      click_on 'Entrar'
    end

    expect(page).to have_content 'Campus Code - Natal 2023'
    within('#natal-2023.carousel') do
      expect(page).to have_content 'Celular Azul'
      expect(page).to have_content '20.000 Pontos'
    end
    expect(page).not_to have_content 'Rebase - Ano Novo 2023'
    expect(page).not_to have_css('#ano-novo-2023.carousel')
  end
  it 'enquanto visitante não vê campanha de empresas' do
    user = create(:user, email: 'zezinho@gmail.com', password: 'senha1234')
    card_fake_response = double('faraday_response', status: 404, body: { errors: 'Cartão não encontrado' })
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(card_fake_response)
    company_fake_response = double('faraday_response', status: 204, body: [])
    allow(Faraday).to receive(:get).with("http://localhost:3000/api/v1/employee_profiles?cpf=#{user.cpf}").and_return(company_fake_response)
    category1 = create(:product_category, name: 'Celulares')
    category2 = create(:product_category, name: 'Eletrônicos')
    create(:product, product_category: category1, code: 'XYZ123456', name: 'Celular Azul', price: 1000)
    create(:product, product_category: category2, code: 'ABC123456', name: 'Celular Branco', price: 2000)
    company1 = create(:company, brand_name: 'Campus Code', registration_number: '12345678000195')
    company2 = create(:company, brand_name: 'Rebase', registration_number: '16190133000108')

    promotionalcampaign1 = create(:promotional_campaign, name: 'Natal 2023', start_date: 1.week.from_now,
                                                         end_date: 1.month.from_now, company: company1)
    promotionalcampaign2 = create(:promotional_campaign, name: 'Ano Novo 2023', start_date: 1.week.from_now,
                                                         end_date: 1.month.from_now, company: company2)
    create(:campaign_category, promotional_campaign: promotionalcampaign1, product_category: category1, discount: 10)
    create(:campaign_category, promotional_campaign: promotionalcampaign2, product_category: category2, discount: 20)

    visit root_path
    click_on 'Entrar'
    within 'form#new_user' do
      fill_in 'E-mail', with: 'zezinho@gmail.com'
      fill_in 'Senha', with: 'senha1234'
      click_on 'Entrar'
    end

    expect(page).not_to have_content 'Campus Code - Natal 2023'
    expect(page).not_to have_css('#natal-2023.carousel')
    expect(page).not_to have_content 'Rebase - Ano Novo 2023'
    expect(page).not_to have_css('#ano-novo-2023.carousel')
  end
  it 'enquanto funcionário demitido, não vê campanha de empresas' do
    user = create(:user, email: 'zezinho@gmail.com', password: 'senha1234')
    company_json_data = Rails.root.join('spec/support/json/cpf_fired_company.json').read
    company_fake_response = double('faraday_response', status: 200, body: company_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:3000/api/v1/employee_profiles?cpf=#{user.cpf}").and_return(company_fake_response)
    card_json_data = Rails.root.join('spec/support/json/card_data_blocked.json').read
    card_fake_response = double('faraday_response', status: 200, body: card_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(card_fake_response)
    category1 = create(:product_category, name: 'Celulares')
    category2 = create(:product_category, name: 'Eletrônicos')
    create(:product, product_category: category1, code: 'XYZ123456', name: 'Celular Azul', price: 1000)
    create(:product, product_category: category2, code: 'ABC123456', name: 'Celular Branco', price: 2000)
    company1 = create(:company, brand_name: 'Campus Code', registration_number: '12345678000195')
    company2 = create(:company, brand_name: 'Rebase', registration_number: '16190133000108')
    promotionalcampaign1 = create(:promotional_campaign, name: 'Natal 2023', start_date: 1.week.from_now,
                                                         end_date: 1.month.from_now, company: company1)
    promotionalcampaign2 = create(:promotional_campaign, name: 'Ano Novo 2023', start_date: 1.week.from_now,
                                                         end_date: 1.month.from_now, company: company2)
    create(:campaign_category, promotional_campaign: promotionalcampaign1, product_category: category1, discount: 10)
    create(:campaign_category, promotional_campaign: promotionalcampaign2, product_category: category2, discount: 20)

    visit root_path
    click_on 'Entrar'
    within 'form#new_user' do
      fill_in 'E-mail', with: 'zezinho@gmail.com'
      fill_in 'Senha', with: 'senha1234'
      click_on 'Entrar'
    end

    expect(page).not_to have_content 'Campus Code - Natal 2023'
    expect(page).not_to have_css('#natal-2023.carousel')
    expect(page).not_to have_content 'Rebase - Ano Novo 2023'
    expect(page).not_to have_css('#ano-novo-2023.carousel')
  end
  it 'enquanto usuário bloqueado, não vê campanha de empresas' do
    user = create(:user, email: 'zezinho@gmail.com', password: 'senha1234')
    company_json_data = Rails.root.join('spec/support/json/cpf_inactive_company.json').read
    company_fake_response = double('faraday_response', status: 200, body: company_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:3000/api/v1/employee_profiles?cpf=#{user.cpf}").and_return(company_fake_response)
    card_json_data = Rails.root.join('spec/support/json/card_data_blocked.json').read
    card_fake_response = double('faraday_response', status: 200, body: card_json_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/cards/#{user.cpf}").and_return(card_fake_response)
    category1 = create(:product_category, name: 'Celulares')
    category2 = create(:product_category, name: 'Eletrônicos')
    create(:product, product_category: category1, code: 'XYZ123456', name: 'Celular Azul', price: 1000)
    create(:product, product_category: category2, code: 'ABC123456', name: 'Celular Branco', price: 2000)
    company1 = create(:company, brand_name: 'Campus Code', registration_number: '12345678000195')
    company2 = create(:company, brand_name: 'Rebase', registration_number: '16190133000108')
    promotionalcampaign1 = create(:promotional_campaign, name: 'Natal 2023', start_date: 1.week.from_now,
                                                         end_date: 1.month.from_now, company: company1)
    promotionalcampaign2 = create(:promotional_campaign, name: 'Ano Novo 2023', start_date: 1.week.from_now,
                                                         end_date: 1.month.from_now, company: company2)
    create(:campaign_category, promotional_campaign: promotionalcampaign1, product_category: category1, discount: 10)
    create(:campaign_category, promotional_campaign: promotionalcampaign2, product_category: category2, discount: 20)

    visit root_path
    click_on 'Entrar'
    within 'form#new_user' do
      fill_in 'E-mail', with: 'zezinho@gmail.com'
      fill_in 'Senha', with: 'senha1234'
      click_on 'Entrar'
    end

    expect(page).not_to have_content 'Campus Code - Natal 2023'
    expect(page).not_to have_css('#natal-2023.carousel')
    expect(page).not_to have_content 'Rebase - Ano Novo 2023'
    expect(page).not_to have_css('#ano-novo-2023.carousel')
    within('nav') do 
      expect(page).to have_content '(Funcionário bloqueado) zezinho@gmail.com'
    end
  end
end
