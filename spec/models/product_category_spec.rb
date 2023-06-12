require 'rails_helper'

RSpec.describe ProductCategory, type: :model do
  describe '#valid?' do
    it 'Falso quando já existe uma categoria com o mesmo nome' do
      first_category = FactoryBot.create(:product_category)
      second_category = ProductCategory.new(name: first_category.name)

      result = second_category.valid?

      expect(result).to be false
    end
  end
end
