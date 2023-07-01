class SeasonalPrice < ApplicationRecord
  belongs_to :product

  validates :value, :start_date, :end_date, presence: true
  validates :start_date, comparison: { greater_than_or_equal_to: :current_date }, if: :start_date_changed?
  validates :end_date, comparison: { greater_than: :start_date }, if: :end_date_changed?
  validates :value, comparison: { less_than: :product_price }, if: -> { value.present? && product.present? }
  validates :value, comparison: { greater_than: 0 }, if: -> { value.present? }
  validate :check_date_overlap, if: -> { product.present? }

  before_validation :check_date, on: :update

  def ongoing?
    current_date.between?(start_date_was, end_date_was)
  end

  def finished?
    current_date > end_date_was
  end

  def future?
    current_date < start_date_was
  end

  def period
    start_date..end_date
  end

  private

  def check_date_overlap
    return unless Product.find(product_id)
                         .seasonal_prices
                         .filter { |sp| sp.id != id }
                         .any? { |seasonal_price| period.overlaps? seasonal_price.period }

    errors.add(:base, :overlap_date_alert)
  end

  def current_date
    Time.zone.today
  end

  def product_price
    product.price
  end

  def check_date
    errors.add(:base, :unpermited_update) if ongoing? || finished?
  end
end
