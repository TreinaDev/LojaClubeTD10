class CustomerAreasController < ApplicationController
  before_action :authenticate_user!, only: %i[index me]
  before_action :prevent_admin, only: %i[index me favorite_tab]
  before_action :prevent_visitor, only: %i[favorite_tab]

  def index; end

  def me
    @user = current_user
  end

  def favorite_tab
    return unless user_signed_in?

    @user = current_user
    @favorites = @user.favorites
  end
end
