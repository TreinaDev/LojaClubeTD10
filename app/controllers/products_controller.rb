class ProductsController < ApplicationController
  include ActiveSupport::NumberHelper

  before_action :set_product, only: [:show]

  def index
    @products = Product.all
  end

  def show; end

  def new
    @product = Product.new
    @categories = ProductCategory.all
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to product_path(@product.id), notice: t('.product_success')
    else
      @categories = ProductCategory.all
      flash.now[:alert] = t('.product_fail')
      render :new
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params
      .require(:product)
      .permit(:name, :code, :description, :brand, :price, :product_category_id, product_images: [])
  end
end
