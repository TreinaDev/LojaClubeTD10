class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :client_addresses, -> { order(default: :desc) }, dependent: :destroy, inverse_of: :user
  has_many :addresses, through: :client_addresses
  has_many :favorites, dependent: :destroy
  has_one :card_info, dependent: :destroy

  enum role: { common: 0, admin: 1 }

  before_create :define_role

  validates :name, :cpf, :phone_number, presence: true
  validates :cpf, cpf: true
  validates :cpf, uniqueness: true
  validate :check_phone_number_length, if: :phone_number_changed?
  validate :cpf_changed_block, if: :cpf_changed?, on: :update

  def formatted_cpf
    cpf = self.cpf
    cpf.to_s.gsub(/(\d{3})(\d{3})(\d{3})(\d{2})/, '\1.\2.\3-\4')
  end

  def address_default
    default_address = client_addresses.find_by(default: true)
    return default_address&.address

  end

  def formatted_phone
    phone_number = self.phone_number
    phone_number.to_s.gsub(/(\d{2})(\d{5})(\d{4})/, '(\1)\2-\3')
  end

  def favorite_products
    favorites.map(&:product)
  end

  def find_card
    Faraday.get("http://localhost:4000/api/v1/cards/#{cpf}")
  end

  private

  def define_role
    self.role = email.present? && email.match(/\A[\w.+-]+@punti.com\z/) ? :admin : :common
  end

  def check_phone_number_length
    return if phone_number.length == 11

    errors.add(:phone_number, :out_of_range)
  end

  def cpf_changed_block
    errors.add(:cpf, :changes_unpermited)
  end
end
