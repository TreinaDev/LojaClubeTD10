class SeasonalPricesController < ApplicationController
  before_action :authenticate_user!, only: %i[index new create update destroy]
  before_action :check_user, only: %i[index new create update destroy]

  def index
    @seasonal_prices = SeasonalPrice.all
  end

  def new
    @seasonal_price = SeasonalPrice.new
    @products = Product.where(active: true)
  end

  def edit
    @seasonal_price = SeasonalPrice.find(params[:id])
  end

  def create
    @seasonal_price = SeasonalPrice.new(new_seasonal_price_params)

    return redirect_to seasonal_prices_path, notice: t('.success') if @seasonal_price.save

    @products = Product.where(active: true)
    flash.now[:alert] = t('.fail')
    render :new
  end

  def update
    @seasonal_price = SeasonalPrice.find(params[:id])

    if @seasonal_price.update(update_seasonal_price_params)
      return redirect_to seasonal_prices_path, notice: t('.success')
    end

    flash.now[:alert] = t('.fail')
    render :edit
  end

  def destroy
    @seasonal_price = SeasonalPrice.find(params[:id])

    return redirect_to seasonal_prices_path, notice: t('.success') if @seasonal_price.destroy

    redirect_to seasonal_prices_path, alert: t('.fail')
  end

  private

  def new_seasonal_price_params
    params.require(:seasonal_price).permit(:value, :start_date, :end_date, :product_id)
  end

  def update_seasonal_price_params
    params.require(:seasonal_price).permit(:value, :start_date, :end_date)
  end
end
