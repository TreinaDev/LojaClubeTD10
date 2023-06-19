require 'rails_helper'

RSpec.describe Orderable, type: :model do
  describe '#valid?' do
    it 'erro com quantidade menor que um' do
      shopping_cart = create(:shopping_cart)
      product = create(:product)

      orderable = Orderable.new(shopping_cart:, product:, quantity: 0)
      result = orderable.valid?

      expect(result).to eq false
      expect(orderable.errors[:quantity]).to include('deve ser maior que 0')
    end
  end
end
