require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '#valid?' do
    it 'Campos obrigatórios' do
      address = Address.new

      address.valid?

      expect(address.errors.full_messages).to include 'Endereço não pode ficar em branco'
      expect(address.errors.full_messages).to include 'Número não pode ficar em branco'
      expect(address.errors.full_messages).to include 'Cidade não pode ficar em branco'
      expect(address.errors.full_messages).to include 'Estado não pode ficar em branco'
      expect(address.errors.full_messages).to include 'CEP não pode ficar em branco'
    end

    it 'CEP deve ter 8 números' do
      address = Address.new(zipcode: '1234')

      address.valid?

      expect(address.errors.full_messages).to include 'CEP não possui o tamanho esperado (8 caracteres)'
    end
  end
end
