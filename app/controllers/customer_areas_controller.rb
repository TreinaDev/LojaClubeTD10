class CustomerAreasController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :prevent_admin, only: [:index]

  def index; end

  def me
    @user = current_user
  end
end
