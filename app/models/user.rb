class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { common: 0, admin: 1 }

  before_create :define_role

  private

  def define_role
    self.role = if email.present? && email.match(/\A[\w.+-]+@punti.com/)
                  :admin
                else
                  :common
                end
  end
end
