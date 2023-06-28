class CustomerAreasController < ApplicationController
  before_action :authenticate_user!, only: %i[index me addresses update_points]
  before_action :prevent_admin, only: %i[index me favorite_tab addresses update_points]
  before_action :prevent_visitor, only: %i[favorite_tab addresses]

  def index; end

  def me
    @user = current_user
  end

  def addresses
    @user = current_user
  end

  def favorite_tab
    return unless user_signed_in?

    @user = current_user
    @favorites = @user.favorites
  end

  def order_history
    # filtra somente os pedidos pendentes
    # faz uma req para cada pedido usando faraday usando o code
    # atualizar os status se o resultado for diferente daquele do model
  end

  def update_points
    begin
      response = current_user.find_card
    rescue StandardError
      return redirect_to customer_areas_path, alert: t('.failed')
    end
    return redirect_to customer_areas_path, alert: t('.not_found') if response.status == 404

    update_point(response)
  end

  private

  def update_point(response)
    @data = JSON.parse(response.body)
    current_user.card_info.update!(points: @data['points'])
    redirect_to customer_areas_path, notice: t('.success')
  end
end
