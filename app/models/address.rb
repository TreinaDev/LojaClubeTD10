class Address < ApplicationRecord
  has_one :user, through: :client_addresses
  has_many :client_addresses, dependent: :destroy

  validates :address, :number, :city, :state, :zipcode, presence: true
  validates :zipcode, length: { is: 8 }

  def full_description
    "#{address} (#{number}), #{city} - #{state}. CEP: #{zipcode}"
  end
end
