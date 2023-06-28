class HomeController < ApplicationController
  def index
    if params[:product_category].blank?
      @products = Product.where(active: true).order(created_at: :desc)
    else
      product_category = params[:product_category]
      @products = Product.where(product_category_id: product_category, active: true).order(created_at: :desc)
    end
  end
end
