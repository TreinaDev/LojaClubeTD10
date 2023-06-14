class ProductsController < ApplicationController
  include ActiveSupport::NumberHelper
  before_action :authenticate_user!, only: %i[index new create edit update]
  before_action :check_user, only: %i[index new create edit update]
  before_action :set_product, only: %i[show edit update]

  def index
    @products = Product.all
  end

  def show; end

  def new
    @product = Product.new
    @categories = ProductCategory.all
  end

  def edit
    @categories = ProductCategory.all
  end

  def create
    @product = Product.new(create_params)

    if @product.save
      redirect_to product_path(@product), notice: t('.product_success')
    else
      @categories = ProductCategory.all
      flash.now[:alert] = t('.product_fail')
      render :new
    end
  end

  def update
    if @product.update(update_params)
      attach_images
      redirect_to product_path(@product), notice: t('.product_success')
    else
      @categories = ProductCategory.all
      flash.now[:alert] = t('.product_fail')
      render :edit
    end
  end

  private

  def attach_images
    return if params[:product][:product_images].blank?

    params[:product][:product_images].each { |image| @product.product_images.attach(image) }
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def update_params
    params
      .require(:product)
      .permit(:name, :code, :description, :brand, :price, :product_category_id)
  end

  def create_params
    params
      .require(:product)
      .permit(:name, :code, :description, :brand, :price, :product_category_id, product_images: [])
  end
end