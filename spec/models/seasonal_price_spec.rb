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
  end
end
