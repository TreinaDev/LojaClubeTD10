class Company < ApplicationRecord
  has_many :promotional_campaigns, dependent: :restrict_with_error
end
