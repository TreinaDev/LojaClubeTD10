require 'rails_helper'

RSpec.describe ProductCategory, type: :model do
  describe '#valid?' do
    it 'Falso quando já existe uma categoria com o mesmo nome' do
      ProductCategory.create!(name: 'Categoria Teste')
      category = ProductCategory.new(name: 'Categoria Teste')

      result = category.valid?

      expect(result).to be false
    end
  end
end
