class HomeController < ApplicationController
  def index
    @products = Product.order(created_at: :desc).limit(5)
  end
end
