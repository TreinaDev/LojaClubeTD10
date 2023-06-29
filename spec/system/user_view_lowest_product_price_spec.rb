require 'rails_helper'

describe 'Usuário vê o menor preço do produto' do
  context 'no card' do
    it 'estando sem campanha ou preço sazonal' do
      user = create(:user)
      create(:product, price: 500, code: 'AFG123456')
      create(:card_info, user:, conversion_tax: 10)
      session_user = { status_user: 'unblocked' }
      allow_any_instance_of(ApplicationController).to receive(:session).and_return(session_user)

      login_as(user)
      visit root_path

      within('.card#AFG123456') do
        expect(page).to have_content '5.000 Pontos'
        expect(page).not_to have_content 'OFF'
      end
    end
    it 'estando no período do preço sazonal, e sem campanha da empresa' do
      user = create(:user)
      product = create(:product, price: 500)
      create(:seasonal_price, product:, value: 300, start_date: 1.week.from_now,
                              end_date: 2.weeks.from_now)
      create(:seasonal_price, product:, value: 250, start_date: 3.weeks.from_now,
                              end_date: 4.weeks.from_now)
      create(:card_info, user:, conversion_tax: 10)
      session_user = { status_user: 'unblocked' }
      allow_any_instance_of(ApplicationController).to receive(:session).and_return(session_user)

      travel_to 8.days.from_now do
        login_as(user)
        visit root_path
      end

      expect(page).not_to have_content 'De 5.000 por 2.500'
      expect(page).not_to have_content '50% OFF'
      expect(page).to have_content 'De 5.000 por 3.000'
      expect(page).to have_content '40% OFF'
    end
    it 'estando no período da campanha e sem preço sazonal para o produto' do
      user = create(:user)
      category1 = create(:product_category, name: 'Celulares')
      category2 = create(:product_category, name: 'Eletrônicos')
      create(:product, product_category: category1, code: 'XYZ123456', name: 'Celular Azul', price: 100)
      create(:product, product_category: category2, code: 'ABC123456', name: 'Celular Branco', price: 200)
      company1 = create(:company, brand_name: 'Campus Code', registration_number: '12345678000195')
      company2 = create(:company, brand_name: 'Rebase', registration_number: '16190133000108')
      promotionalcampaign1 = create(:promotional_campaign, name: 'Natal 2023', start_date: 1.week.from_now,
                                                           end_date: 1.month.from_now, company: company1)
      promotionalcampaign2 = create(:promotional_campaign, name: 'Ano Novo 2023', start_date: 1.week.from_now,
                                                           end_date: 1.month.from_now, company: company2)
      create(:campaign_category, promotional_campaign: promotionalcampaign1, product_category: category1, discount: 10)
      create(:campaign_category, promotional_campaign: promotionalcampaign2, product_category: category2, discount: 20)
      create(:card_info, user:, conversion_tax: 10)
      session_user = { status_user: 'unblocked', company_cnpj: '12345678000195' }
      allow_any_instance_of(ApplicationController).to receive(:session).and_return(session_user)

      travel_to 8.days.from_now do
        login_as(user)
        visit root_path
      end

      expect(current_path).to eq root_path
      expect(page).to have_content 'De 1.000 por 900'
      expect(page).to have_content '10% OFF'
      expect(page).not_to have_content 'De 2.000 por 1.600'
      expect(page).not_to have_content '20% OFF'
    end
    it 'estando no período da campanha e com preço sazonal, sendo o da campanha menor' do
      user = create(:user)
      category = create(:product_category, name: 'Celulares')
      product = create(:product, product_category: category, code: 'XYZ123456', name: 'Celular Azul', price: 100)
      company = create(:company, brand_name: 'Campus Code', registration_number: '12345678000195')
      create(:seasonal_price, product:, value: 50, start_date: 1.week.from_now,
                              end_date: 2.weeks.from_now)
      promotionalcampaign = create(:promotional_campaign, name: 'Natal 2023', start_date: 1.week.from_now,
                                                          end_date: 1.month.from_now, company:)
      create(:campaign_category, promotional_campaign: promotionalcampaign, product_category: category, discount: 70)
      create(:card_info, user:, conversion_tax: 10)
      session_user = { status_user: 'unblocked', company_cnpj: '12345678000195' }
      allow_any_instance_of(ApplicationController).to receive(:session).and_return(session_user)

      travel_to 8.days.from_now do
        login_as(user)
        visit root_path
      end

      expect(page).to have_content 'De 1.000 por 300'
      expect(page).to have_content '70% OFF'
    end
    it 'estando no período da campanha e com preço sazonal, sendo do preço sazonal menor' do
      user = create(:user)
      category = create(:product_category, name: 'Celulares')
      product = create(:product, product_category: category, code: 'XYZ123456', name: 'Celular Azul', price: 100)
      company = create(:company, brand_name: 'Campus Code', registration_number: '12345678000195')
      create(:seasonal_price, product:, value: 50, start_date: 1.week.from_now,
                              end_date: 2.weeks.from_now)
      promotionalcampaign = create(:promotional_campaign, name: 'Natal 2023', start_date: 1.week.from_now,
                                                          end_date: 1.month.from_now, company:)
      create(:campaign_category, promotional_campaign: promotionalcampaign, product_category: category, discount: 20)
      create(:card_info, user:, conversion_tax: 10)
      session_user = { status_user: 'unblocked', company_cnpj: '12345678000195' }
      allow_any_instance_of(ApplicationController).to receive(:session).and_return(session_user)

      travel_to 8.days.from_now do
        login_as(user)
        visit root_path
      end

      expect(page).to have_content 'De 1.000 por 500'
      expect(page).to have_content '50% OFF'
    end
  end
  context 'no detalhes' do
    it 'estando sem campanha ou preço sazonal' do
      user = create(:user)
      create(:product, price: 500, name: 'Calculadora', code: 'AFG123456')
      create(:card_info, user:, conversion_tax: 10)
      session_user = { status_user: 'unblocked' }
      allow_any_instance_of(ApplicationController).to receive(:session).and_return(session_user)

      login_as(user)
      visit root_path
      click_on 'Calculadora'

      expect(page).to have_content '5.000 Pontos'
      expect(page).not_to have_content 'OFF'
      expect(page).not_to have_content 'Oferta válida'
    end
    it 'estando no período do preço sazonal, e sem capanha da empresa' do
      user = create(:user)
      product = create(:product, name: 'Calculadora', price: 10)
      seasonal_price = create(:seasonal_price, product:, value: 5, start_date: 1.week.from_now,
                                               end_date: 2.weeks.from_now)
      create(:seasonal_price, product:, value: 3, start_date: 3.weeks.from_now,
                              end_date: 4.weeks.from_now)
      create(:card_info, user:, conversion_tax: 10)
      create(:company, brand_name: 'Campus Code', registration_number: '12345678000195')
      session_user = { status_user: 'unblocked', company_cnpj: '12345678000195' }
      allow_any_instance_of(ApplicationController).to receive(:session).and_return(session_user)

      travel_to 8.days.from_now do
        login_as(user)
        visit root_path
        click_on 'Calculadora'
      end

      expect(page).not_to have_content 'De 100 por 30'
      expect(page).not_to have_content '70% OFF'
      expect(page).to have_content 'De 100 por 50'
      expect(page).to have_content '50% OFF'
      expect(page).to have_content "Oferta válida até #{I18n.l(seasonal_price.end_date)}"
    end
    it 'estando no período da campanha e sem preço sazonal para o produto' do
      user = create(:user)
      category1 = create(:product_category, name: 'Celulares')
      category2 = create(:product_category, name: 'Eletrônicos')
      create(:product, product_category: category1, code: 'XYZ123456', name: 'Celular Azul', price: 100)
      create(:product, product_category: category2, code: 'ABC123456', name: 'Celular Branco', price: 200)
      company1 = create(:company, brand_name: 'Campus Code', registration_number: '12345678000195')
      company2 = create(:company, brand_name: 'Rebase', registration_number: '16190133000108')
      promotionalcampaign1 = create(:promotional_campaign, name: 'Natal 2023', start_date: 1.week.from_now,
                                                           end_date: 1.month.from_now, company: company1)
      promotionalcampaign2 = create(:promotional_campaign, name: 'Ano Novo 2023', start_date: 1.week.from_now,
                                                           end_date: 1.month.from_now, company: company2)
      create(:campaign_category, promotional_campaign: promotionalcampaign1, product_category: category1, discount: 10)
      create(:campaign_category, promotional_campaign: promotionalcampaign2, product_category: category2, discount: 20)
      create(:card_info, user:, conversion_tax: 10)
      session_user = { status_user: 'unblocked', company_cnpj: '12345678000195' }
      allow_any_instance_of(ApplicationController).to receive(:session).and_return(session_user)

      travel_to 8.days.from_now do
        login_as(user)
        visit root_path
        within('#natal-2023.carousel') do
          click_on 'Celular Azul'
        end
      end

      expect(page).to have_content 'De 1.000 por 900'
      expect(page).to have_content '10% OFF'
      expect(page).not_to have_content 'De 2.000 por 1.600'
      expect(page).not_to have_content '20% OFF'
      expect(page).to have_content "Oferta válida até #{I18n.l(promotionalcampaign1.end_date)}"
    end
    it 'estando no período da campanha e com preço sazonal, sendo o da campanha menor' do
      user = create(:user)
      category = create(:product_category, name: 'Celulares')
      product = create(:product, product_category: category, code: 'XYZ123456', name: 'Celular Azul', price: 100)
      company = create(:company, brand_name: 'Campus Code', registration_number: '12345678000195')
      create(:seasonal_price, product:, value: 50, start_date: 1.week.from_now,
                              end_date: 2.weeks.from_now)
      promotionalcampaign = create(:promotional_campaign, name: 'Natal 2023', start_date: 1.week.from_now,
                                                          end_date: 1.month.from_now, company:)
      create(:campaign_category, promotional_campaign: promotionalcampaign, product_category: category, discount: 70)
      create(:card_info, user:, conversion_tax: 10)
      session_user = { status_user: 'unblocked', company_cnpj: '12345678000195' }
      allow_any_instance_of(ApplicationController).to receive(:session).and_return(session_user)

      travel_to 8.days.from_now do
        login_as(user)
        visit root_path
        within('#natal-2023.carousel') do
          click_on 'Celular Azul'
        end
      end

      expect(page).to have_content 'De 1.000 por 300'
      expect(page).to have_content '70% OFF'
      expect(page).to have_content "Oferta válida até #{I18n.l(promotionalcampaign.end_date)}"
    end
    it 'estando no período da campanha e com preço sazonal, sendo do preço sazonal menor' do
      user = create(:user)
      category = create(:product_category, name: 'Celulares')
      product = create(:product, product_category: category, code: 'XYZ123456', name: 'Celular Azul', price: 100)
      company = create(:company, brand_name: 'Campus Code', registration_number: '12345678000195')
      seasonal_price = create(:seasonal_price, product:, value: 50, start_date: 1.week.from_now,
                                               end_date: 2.weeks.from_now)
      promotionalcampaign = create(:promotional_campaign, name: 'Natal 2023', start_date: 1.week.from_now,
                                                          end_date: 1.month.from_now, company:)
      create(:campaign_category, promotional_campaign: promotionalcampaign, product_category: category, discount: 20)
      create(:card_info, user:, conversion_tax: 10)
      session_user = { status_user: 'unblocked', company_cnpj: '12345678000195' }
      allow_any_instance_of(ApplicationController).to receive(:session).and_return(session_user)

      travel_to 8.days.from_now do
        login_as(user)
        visit root_path
        within('#natal-2023.carousel') do
          click_on 'Celular Azul'
        end
      end

      expect(page).to have_content 'De 1.000 por 500'
      expect(page).to have_content '50% OFF'
      expect(page).to have_content "Oferta válida até #{I18n.l(seasonal_price.end_date)}"
    end
  end
end
