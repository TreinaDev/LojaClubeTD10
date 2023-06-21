class SeasonalPrice < ApplicationRecord
  belongs_to :product

  validates :value, :start_date, :end_date, presence: true
  validates :start_date, comparison: { greater_than: :current_date }
  validates :end_date, comparison: { greater_than: :start_date }

  private

  def current_date
    Time.zone.today
  end
end
