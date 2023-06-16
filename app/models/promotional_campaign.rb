class PromotionalCampaign < ApplicationRecord
  belongs_to :company
  validates :name, :start_date, :end_date, presence: true

  validate :check_start_date, :check_end_date, on: :create

  private

  def check_start_date
    return unless start_date.present? && start_date < Time.zone.today

    errors.add(:start_date, 'deve ser no futuro')
  end

  def check_end_date
    return unless end_date.present? && end_date <= start_date

    errors.add(:end_date, 'não pode ser anterior à data inicial')
  end
end
