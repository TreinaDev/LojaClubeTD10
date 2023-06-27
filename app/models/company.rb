class Company < ApplicationRecord
  has_many :promotional_campaigns, dependent: :restrict_with_error
  validates :brand_name, :registration_number, :corporate_name, presence: true
end
