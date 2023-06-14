class HomeController < ApplicationController
  def index
    @products = Product.order(created_at: :desc)
    @products_category_last = ProductCategory.last
  end
end
