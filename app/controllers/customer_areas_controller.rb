class CustomerAreasController < ApplicationController
  before_action :authenticate_user!, only: %i[index me addresses]
  before_action :prevent_admin, only: %i[index me]

  def index; end

  def me
    @user = current_user
  end

  def addresses
    @user = current_user
  end
end
