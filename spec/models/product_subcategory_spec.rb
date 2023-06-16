require 'rails_helper'

RSpec.describe ProductSubcategory, type: :model do
  describe '#valid?' do
    it 'Campos obrigatórios' do
      subcategory = ProductSubcategory.new

      subcategory.valid?

      expect(subcategory.errors.full_messages).to include 'Nome não pode ficar em branco'
      expect(subcategory.errors.full_messages).to include 'Categoria de produtos é obrigatório(a)'
    end
  end
end
