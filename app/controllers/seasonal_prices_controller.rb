class SeasonalPricesController < ApplicationController
  include ActiveSupport::NumberHelper

  before_action :authenticate_user!, only: %i[index]
  before_action :check_user, only: %i[index]

  def index
    @seasonal_prices = SeasonalPrice.all
  end

  def new
    @seasonal_price = SeasonalPrice.new
    @products = Product.all
  end

  def create
    @seasonal_price = SeasonalPrice.new(seasonal_price_params)

    return redirect_to seasonal_prices_path, notice: t('.success') if @seasonal_price.save

    @products = Product.all
    flash.now[:alert] = t('.fail')
    render :new
  end

  private

  def seasonal_price_params
    params.require(:seasonal_price).permit(:value, :start_date, :end_date, :product_id)
  end
end
