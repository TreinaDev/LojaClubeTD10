class CustomerAreasController < ApplicationController
  before_action :authenticate_user!, only: %i[index me addresses extract_tab]
  before_action :prevent_admin, only: %i[index me favorite_tab addresses extract_tab]
  before_action :prevent_visitor, only: %i[favorite_tab addresses]

  def index; end

  def me
    @user = current_user
  end

  def addresses
    @user = current_user
  end

  def extract_tab
    card_response = Faraday.get("http://localhost:4000/api/v1/cards/#{current_user.cpf}")
    card = JSON.parse(card_response.body)
    extract_response = Faraday.get("http://localhost:4000/api/v1/extracts?card_number=#{card['number']}")
    @operations = JSON.parse(extract_response.body)
  rescue StandardError
    flash.now[:alert] = t('.failed')
  end

  def favorite_tab
    return unless user_signed_in?

    @user = current_user
    @favorites = @user.favorites
  end
end
