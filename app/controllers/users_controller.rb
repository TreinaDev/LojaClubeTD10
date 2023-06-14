class UsersController < ApplicationController
  def update_phone
    @user = current_user
    phone = params[:phone_number]
    phone = phone.to_s.gsub(/^(\+)|\D/, '\1')
    if @user.update(phone_number: phone)
      flash[:notice] = t('.success_message')
      return redirect_to me_path
    end
    flash[:alert] = t('.error_message')
    redirect_to me_path
  end
end
