class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: { common: 0, admin: 1 }

  def formatted_cpf
    cpf = self.cpf
    cpf.to_s.gsub(/(\d{3})(\d{3})(\d{3})(\d{2})/, '\1.\2.\3-\4')
  end

  def formatted_phone
    phone_number = self.phone_number
    phone_number.to_s.gsub(/(\d{2})(\d{5})(\d{4})/, '(\1)\2-\3')
  end
end
