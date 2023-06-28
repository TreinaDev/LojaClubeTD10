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
    card_response = current_user.find_card
    card = JSON.parse(card_response.body)
    extract_response = Faraday.get("http://localhost:4000/api/v1/extracts?card_number=#{card['number']}")
    @operations = JSON.parse(extract_response.body)
  rescue StandardError
    flash.now[:alert] = t('.failed')
    @error_message = 'Não foi possível obter informações do extrato deste cartão.'
  end

  def favorite_tab
    return unless user_signed_in?

    @user = current_user
    @favorites = @user.favorites
  end
end
