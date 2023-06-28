require 'rails_helper'

describe 'Usuário vê o menor preço do produto' do
  context 'no card' do
    it 'estando no período do preço sazonal' do
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
  end  
  context 'no detalhes' do
    it 'estando no período do preço sazonal' do
      user = create(:user)
      product = create(:product, name: 'Calculadora', price: 10)
      seasonal_price = create(:seasonal_price, product:, value: 5, start_date: 1.week.from_now,
                                                end_date: 2.weeks.from_now)
      create(:seasonal_price, product:, value: 3, start_date: 3.weeks.from_now,
                              end_date: 4.weeks.from_now)
      create(:card_info, user:, conversion_tax: 10)
      session_user = { status_user: 'unblocked' }
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
  end
end
