require 'rails_helper'

RSpec.describe Company, type: :model do
  describe '#valid?' do
    it 'inválido quando o Nome Fantasia é vazio' do
      promotional_campaign = Company.new(brand_name: '')

      promotional_campaign.valid?
      result = promotional_campaign.errors.include?(:brand_name)

      expect(result).to be true
      expect(promotional_campaign.errors[:brand_name]).to include('não pode ficar em branco')
    end

    it 'inválido quando o CNPJ é vazio' do
      promotional_campaign = Company.new(registration_number: '')

      promotional_campaign.valid?
      result = promotional_campaign.errors.include?(:registration_number)

      expect(result).to be true
      expect(promotional_campaign.errors[:registration_number]).to include('não pode ficar em branco')
    end

    it 'inválido quando o Nome Coorporativo é vazio' do
      promotional_campaign = Company.new(corporate_name: '')

      promotional_campaign.valid?
      result = promotional_campaign.errors.include?(:corporate_name)

      expect(result).to be true
      expect(promotional_campaign.errors[:corporate_name]).to include('não pode ficar em branco')
    end
  end
end
