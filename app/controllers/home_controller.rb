class HomeController < ApplicationController
  def index
    @products = Product.where(active: true).order(created_at: :desc)

    set_campaigns
  end
end
