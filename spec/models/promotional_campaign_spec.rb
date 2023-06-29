require 'rails_helper'

RSpec.describe PromotionalCampaign, type: :model do
  describe '#valid?' do
    it 'inválido quando o nome é vazio' do
      promotional_campaign = PromotionalCampaign.new(name: '')

      promotional_campaign.valid?
      result = promotional_campaign.errors.include?(:name)

      expect(result).to be true
      expect(promotional_campaign.errors[:name]).to include('não pode ficar em branco')
    end

    it 'inválido quando a data inicial está vazia' do
      promotional_campaign = PromotionalCampaign.new(start_date: '')

      promotional_campaign.valid?
      result = promotional_campaign.errors.include?(:start_date)

      expect(result).to be true
      expect(promotional_campaign.errors[:start_date]).to include('não pode ficar em branco')
    end

    it 'inválido quando a data final está vazia' do
      promotional_campaign = PromotionalCampaign.new(end_date: '')

      promotional_campaign.valid?
      result = promotional_campaign.errors.include?(:end_date)

      expect(result).to be true
      expect(promotional_campaign.errors[:end_date]).to include('não pode ficar em branco')
    end

    it 'inválido quando a data inicial é menor que a data atual' do
      promotional_campaign = PromotionalCampaign.new(start_date: Time.zone.today)

      promotional_campaign.valid?
      result = promotional_campaign.errors.include?(:start_date)

      expect(result).to be true
      expect(promotional_campaign.errors[:start_date]).to include('deve ser no futuro')
    end

    it 'inválido quando a data final é anterior a data inicial' do
      promotional_campaign = PromotionalCampaign.new(start_date: 1.day.from_now, end_date: 1.day.ago)

      promotional_campaign.valid?
      result = promotional_campaign.errors.include?(:end_date)

      expect(result).to be true
      expect(promotional_campaign.errors[:end_date]).to include('deve ser maior que a data inicial')
    end
  end
end
