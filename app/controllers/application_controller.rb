class ApplicationController < ActionController::Base
  before_action :load_product_categories

  private

  def load_product_categories
    @product_categories = ProductCategory.all
  end
end
