class CustomerAreasController < ApplicationController
  before_action :authenticate_user!, only: %i[index me]
  before_action :prevent_admin, only: %i[index me]

  def index; end

  def me
    @user = current_user
  end

  def favorite_tab
    @user = current_user
    @products = @user.favorite_products
  end
end
