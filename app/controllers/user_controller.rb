class UserController < ApplicationController
  def show
    user_id = params[:id]
    @user = User.find(user_id)
  end
end
