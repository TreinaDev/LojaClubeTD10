require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do
    it 'erro com valores inválidos' do
      user = create(:user)

      order = Order.new(total_value: 0, discount_amount: -1, final_value: 0, cpf: '18463419062', user:)
      result = order.valid?

      expect(result).to eq false
      expect(order.errors[:total_value]).to include('deve ser maior que 0')
      expect(order.errors[:final_value]).to include('deve ser maior que 0')
      expect(order.errors[:discount_amount]).to include('deve ser maior ou igual a 0')
    end
  end
end
