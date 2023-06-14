class PromotionalCampaign < ApplicationRecord
  belongs_to :company
  validates :name, :start_date, :end_date, presence: true
end
