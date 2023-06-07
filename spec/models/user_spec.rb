require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    it 'Campos obrigatótrios' do
      user = User.new

      user.valid?

      expect(user.errors[:name]).to include 'não pode ficar em branco'
      expect(user.errors[:cpf]).to include 'não pode ficar em branco'
      expect(user.errors[:phone_number]).to include 'não pode ficar em branco'
    end

    it 'CPF válido' do
      # Arrange
      user = FactoryBot.build(:user, cpf: '20223956030')

      # Act
      user.valid?

      # Assert
      expect(user.errors[:cpf]).to include 'inválido'
    end

    it 'Formato do email' do
      user = FactoryBot.build(:user, email: 'mailsampletest.com')

      user.valid?

      expect(user.errors[:email]).to include 'não é válido'
    end

    it 'tamanho do número de telefone' do
      # Arrange
      user = FactoryBot.build(:user, phone_number: '12345')

      # Act
      user.valid?

      # Assert
      expect(user.errors[:phone_number]).to include 'deve conter 11 dígitos.'
    end
  end
end
