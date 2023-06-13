class FavoritesController < ApplicationController 
  def create 
    @favorite = Favorite.new(favorite_params)
    @product = Product.find(params[:favorite][:product_id])  
    @favorite.save
    redirect_to product_path(@product), notice: "#{@product.name} está na sua lista de produtos favoritos"
  end

  private 

  def favorite_params
    params
      .require(:favorite)
      .permit(:user_id, :product_id)
  end
end