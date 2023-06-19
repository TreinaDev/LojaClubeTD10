class FavoritesController < ApplicationController
  before_action :set_favorite, only: [:destroy]

  def create
    @favorite = Favorite.new(favorite_params)
    @product = Product.find(params[:favorite][:product_id])
    @favorite.save
    redirect_to product_path(@product), notice: "#{@product.name} está na sua lista de produtos favoritos"
  end

  def destroy
    if @favorite.destroy
      if request.referer
        redirect_to request.referer, notice: t('.destroy_success')
      else
        redirect_to product_path(@favorite.product_id)
      end
    else
      redirect_to request.referer, alert: t('.destroy_fails')
    end
  end

  private

  def favorite_params
    params
      .require(:favorite)
      .permit(:user_id, :product_id)
  end

  def set_favorite
    @favorite = Favorite.find params[:id]
  end
end
