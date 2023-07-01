class HomeController < ApplicationController
  def index
    if params[:product_category].blank?
      @products = Product.where(active: true).order(created_at: :desc)
    else
      product_category = ProductCategory.find(params[:product_category])
      @products = Product.where(product_category:, active: true).order(created_at: :desc).to_a
      @products_sub_categories = product_category.subcategories.map(&:products).flatten
      @products.concat(@products_sub_categories)
    end

    set_campaigns
  end
end
