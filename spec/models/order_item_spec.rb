require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe '#valid?' do
    it 'erro com quantidade inválida' do
      order_item = OrderItem.new(quantity: 0)
      result = order_item.valid?

      expect(result).to eq false
      expect(order_item.errors[:quantity]).to include('deve ser maior que 0')
    end
  end
end
