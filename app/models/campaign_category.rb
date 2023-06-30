class CampaignCategory < ApplicationRecord
  belongs_to :promotional_campaign
  belongs_to :product_category

  validates :discount, presence: true
  validates :discount, numericality: { greater_than: 0 }

  validate :in_progress, if: -> { promotional_campaign.present? }
  validate :finished, if: -> { promotional_campaign.present? }

  def future?
    promotional_campaign = find_promotional_campaign
    Time.zone.today < promotional_campaign.start_date
  end

  def find_promotional_campaign
    PromotionalCampaign.find(promotional_campaign_id)
  end

  def in_progress
    promotional_campaign = find_promotional_campaign
    errors.add(:base, :campaign_in_progress) if current_date.between?(promotional_campaign.start_date,
                                                                      promotional_campaign.end_date)
  end

  def finished
    promotional_campaign = find_promotional_campaign
    errors.add(:base, :campaign_finished) if current_date > promotional_campaign.end_date
  end

  private

  def current_date
    Time.zone.today
  end
end
