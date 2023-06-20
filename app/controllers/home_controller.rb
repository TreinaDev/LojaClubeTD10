class HomeController < ApplicationController
  def index
    @products = Product.order(created_at: :desc).filter { |p| p.product_category.active? }
  end
end
