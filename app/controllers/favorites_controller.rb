class FavoritesController < ApplicationController
  def create
    @favorite = Favorite.new(favorite_params)
    @product = Product.find(params[:favorite][:product_id])
    @favorite.save
    redirect_to product_path(@product), notice: "#{@product.name} está na sua lista de produtos favoritos"
  end

  def destroy
    @favorite = Favorite.find params[:id]
    if @favorite.destroy
      redirect_to request.referer, notice: t('.destroy_success')
    else
      redirect_to product_path(@favorite.product_id)
    end
  end

  private

  def favorite_params
    params
      .require(:favorite)
      .permit(:user_id, :product_id)
  end
end
