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
  end
end
