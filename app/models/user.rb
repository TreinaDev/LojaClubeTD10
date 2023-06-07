class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { common: 0, admin: 1 }

  before_create :define_role

  validates :name, :cpf, :phone_number, presence: true
  validates :cpf, cpf: true
  validate :check_phone_number_length, if: :phone_number_changed?

  private

  def define_role
    self.role = if email.present? && email.match(/\A[\w.+-]+@punti.com/)
                  :admin
                else
                  :common
                end
  end

  def check_phone_number_length
    return if phone_number.length == 11

    errors.add(:phone_number, :out_of_range)
  end
end
