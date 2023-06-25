class HomeController < ApplicationController
  def index
    @products = Product.where(active: true).order(created_at: :desc).filter { |p| p.product_category.active? }
  end
end
