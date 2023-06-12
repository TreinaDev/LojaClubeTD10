class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { common: 0, admin: 1 }

  before_create :define_role

  validates :email, :password, :name, :cpf, :phone_number, presence: true
  validates :cpf, cpf: true
  validates :cpf, uniqueness: true
  validate :check_phone_number_length, if: :phone_number_changed?
  validate :cpf_changed_block, if: :cpf_changed?, on: :update

  private

  def define_role
    self.role = email.present? && email.match(/\A[\w.+-]+@punti.com/) ? :admin : :common
  end

  def check_phone_number_length
    return if phone_number.length == 11

    errors.add(:phone_number, :out_of_range)
  end

  def cpf_changed_block
    errors.add(:cpf, :changes_unpermited)
  end
end
