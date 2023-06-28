require 'rails_helper'

RSpec.describe SeasonalPrice, type: :model do
  context '#valid?' do
    it 'inválido quando um dos atributos está em branco' do
      seasonal_price = SeasonalPrice.new

      seasonal_price.valid?

      errors_messages = seasonal_price.errors.full_messages

      expect(errors_messages).to include 'Valor não pode ficar em branco'
      expect(errors_messages).to include 'Data de início não pode ficar em branco'
      expect(errors_messages).to include 'Data de encerramento não pode ficar em branco'
      expect(errors_messages).to include 'Produto é obrigatório(a)'
    end

    it 'data de início deve ser futura' do
      seasonal_price = SeasonalPrice.new(
        start_date: 1.week.ago, end_date: 1.week.from_now
      )

      seasonal_price.valid?

      errors_messages = seasonal_price.errors.full_messages

      expect(errors_messages).to include 'Data de início deve ser futura'
    end

    it 'data de encerramento deve suceder data de início' do
      seasonal_price = SeasonalPrice.new(
        start_date: 1.week.from_now, end_date: 1.week.ago
      )

      seasonal_price.valid?

      errors_messages = seasonal_price.errors.full_messages

      expect(errors_messages).to include 'Data de encerramento deve suceder data de início'
    end

    it 'inválido quando valor do preço sazonal é maior ou igual ao preço do produto' do
      product = create(:product, price: 10)
      seasonal_price = SeasonalPrice.new(product:, value: 11,
                                         start_date: 1.week.from_now.to_date,
                                         end_date: 2.weeks.from_now.to_date)

      seasonal_price.valid?
      errors_messages = seasonal_price.errors.full_messages

      expect(errors_messages).to include 'Valor não pode ser maior ou igual ao preço de produto'
    end

    it 'inválido quando valor de preço sazonal é menor ou igual a zero' do
      first_seasonal_price = SeasonalPrice.new(value: 0)
      second_seasonal_price = SeasonalPrice.new(value: -1)

      first_seasonal_price.valid?
      first_errors_messages = first_seasonal_price.errors.full_messages
      second_seasonal_price.valid?
      second_errors_messages = second_seasonal_price.errors.full_messages

      expect(first_errors_messages).to include 'Valor precisa ser maior que zero'
      expect(second_errors_messages).to include 'Valor precisa ser maior que zero'
    end

    it 'inválido quando há sobreposição de datas com outros preço sazonais para o mesmo produto' do
      product = create(:product, price: 200)

      create(:seasonal_price, start_date: 1.day.from_now, end_date: 7.days.from_now, value: 100, product:)

      seasonal_price = build(
        :seasonal_price, start_date: 3.days.from_now, end_date: 5.days.from_now, value: 100, product:
      )

      seasonal_price.valid?
      errors_messages = seasonal_price.errors.full_messages

      expect(errors_messages).to include 'Não pode haver preço sazonal com sobreposição de datas para um mesmo produto'
    end

    context 'com influência do tempo' do
      it 'não pode editar se tiver sendo aplicado' do
        seasonal_price = create(:seasonal_price, start_date: 1.day.from_now, end_date: 1.week.from_now)

        travel_to 3.days.from_now do
          approved = seasonal_price.update(value: (seasonal_price.value - 1))
          errors_messages = seasonal_price.errors.full_messages

          expect(approved).to eq false
          expect(errors_messages).to include 'Não é possível alterar um preço sazonal em andamento'
        end
      end
    end
  end
end
