require 'rails_helper'

RSpec.describe CampaignCategory, type: :model do
  describe '#valid?' do
    it 'inválido quando o desconto é vazio' do
      campaign_category = CampaignCategory.new(discount: '')

      campaign_category.valid?
      result = campaign_category.errors.include?(:discount)

      expect(result).to be true
      expect(campaign_category.errors[:discount]).to include('não pode ficar em branco')
    end

    it 'inválido quando o desconto é menor que zero' do
      campaign_category = CampaignCategory.new(discount: -1)

      campaign_category.valid?
      result = campaign_category.errors.include?(:discount)

      expect(result).to be true
      expect(campaign_category.errors[:discount]).to include('deve estar em 1..99')
    end

    it 'inválido quando o desconto é igual a zero' do
      campaign_category = CampaignCategory.new(discount: 0)

      campaign_category.valid?
      result = campaign_category.errors.include?(:discount)

      expect(result).to be true
      expect(campaign_category.errors[:discount]).to include('deve estar em 1..99')
    end

    it 'inválido quando o desconto é maior que 99' do
      campaign_category = CampaignCategory.new(discount: 100)

      campaign_category.valid?
      result = campaign_category.errors.include?(:discount)

      expect(result).to be true
      expect(campaign_category.errors[:discount]).to include('deve estar em 1..99')
    end

    it 'válido quando o desconto é maior que zero' do
      campaign_category = create(:campaign_category, discount: 1)

      result = campaign_category.valid?

      expect(result).to be true
    end

    it 'inválido quando adiciona categoria em uma campanha em andamento' do
      create(:company)
      category1 = create(:product_category)
      travel_to 2.weeks.ago do
        @promotional_campaign = create(:promotional_campaign, start_date: 2.days.from_now, end_date: 2.months.from_now)
      end
      campaign_category = CampaignCategory.new(promotional_campaign: @promotional_campaign,
                                               product_category_id: category1, discount: 10)

      campaign_category.valid?
      result = campaign_category.errors.include?(:base)

      expect(result).to be true
      expect(campaign_category.errors[:base]).to \
        include('Não é possível adicionar categoria em uma campanha em andamento')
    end

    it 'inválido quando adiciona categoria em uma campanha em andamento' do
      create(:company)
      category1 = create(:product_category)
      travel_to 6.months.ago do
        @promotional_campaign = create(:promotional_campaign)
      end
      campaign_category = CampaignCategory.new(promotional_campaign: @promotional_campaign,
                                               product_category_id: category1, discount: 10)

      campaign_category.valid?
      result = campaign_category.errors.include?(:base)

      expect(result).to be true
      expect(campaign_category.errors[:base]).to \
        include('Não é possível adicionar categoria em uma campanha finalizada')
    end
  end
end
