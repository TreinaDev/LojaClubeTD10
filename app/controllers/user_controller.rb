class UserController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :prevent_admin, only: [:show]
  def show
    user_id = params[:id]
    if user_id.to_i == current_user.id
      @user = User.find(user_id)
    else
      redirect_to root_path, alert: t('.fail')
    end
  end
end
