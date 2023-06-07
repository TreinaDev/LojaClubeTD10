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
      expect(user.errors[:cpf]).to include 'inválido.'
    end

    it 'CPF deve conter 11 números' do
      user = FactoryBot.build(:user, cpf: '1234567890')

      user.valid?

      expect(user.errors[:cpf]).to include 'deve conter 11 números.'
    end

    it 'deve conter apenas números' do
      user = FactoryBot.build(:user, cpf: 'abc12345678')

      user.valid?

      expect(user.errors[:cpf]).to include 'deve conter apenas números.'
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
      expect(user.errors[:phone_number]).to include 'deve conter 11 números.'
    end
  end

  context '#role' do
    it 'Cadastro de usuário regular' do
      user = FactoryBot.create(:user, email: 'rick@mail.com.br')

      expect(user.role).to eq 'common'
    end

    it 'Administradores devem ter email com dominio @punti.com' do
      user = FactoryBot.create(:user, email: 'sandro@punti.com')

      expect(user.role).to eq 'admin'
    end
  end
end
