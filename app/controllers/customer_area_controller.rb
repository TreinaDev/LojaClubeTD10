class CustomerAreaController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :prevent_admin, only: [:index]

  def index; end
end
