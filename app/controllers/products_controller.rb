class ProductsController < ApplicationController
  include ActiveSupport::NumberHelper
  before_action :authenticate_user!, only: %i[index new create edit update
                                              deactivate reactivate deactivate_all reactivate_all campaigns_promotions]
  before_action :check_user, only: %i[index new create edit update deactivate reactivate
                                      deactivate_all reactivate_all campaigns_promotions]
  before_action :set_product, only: %i[show edit update deactivate reactivate campaigns_promotions]

  def index
    @products = Product.order(:name)
    return if params[:query_products].blank?

    @query = params[:query_products]
    @products = @products.where('name LIKE ?', "%#{@query}%")
  end

  def campaigns_promotions
    @campaigns = @product.product_category.promotional_campaigns.order(:start_date)
    @promotions = @product.seasonal_prices.order(:start_date)
  end

  def show
    if @product.active == true || current_user&.admin?
      favorite_option(@product)
    else
      redirect_to root_path, alert: t('.not_access')
    end
  end

  def new
    @product = Product.new
    @categories = ProductCategory.where(parent_id: nil, active: true)
  end

  def edit
    @categories = ProductCategory.where(parent_id: nil, active: true)
  end

  def create
    @product = Product.new(create_params)

    if @product.save
      redirect_to product_path(@product), notice: t('.product_success')
    else
      @categories = ProductCategory.where(parent_id: nil, active: true)
      flash.now[:alert] = t('.product_fail')
      render :new
    end
  end

  def update
    if @product.update(update_params)
      attach_images
      redirect_to product_path(@product), notice: t('.product_success')
    else
      @categories = ProductCategory.where(parent_id: nil, active: true)
      flash.now[:alert] = t('.product_fail')
      render :edit
    end
  end

  def search
    @query = params['query']
    return redirect_to root_path, alert: t('.qwery_empty') if @query == ''

    @products = Product.where('name LIKE ? AND active = ?', "%#{@query}%", true)
    @quantity = @products.length
  end

  def deactivate
    @query = params[:query_products]
    @product.update(active: false)
    redirect_to products_path(query_products: @query), notice: t('.product_success')
  end

  def reactivate
    @query = params[:query_products]
    @product.update(active: true)
    redirect_to products_path(query_products: @query), notice: t('.product_success')
  end

  def deactivate_all
    @query = params[:query_products]
    @products = Product.where('name LIKE ?', "%#{@query}%").update(active: false)
    redirect_to products_path(query_products: @query), notice: t('.product_success')
  end

  def reactivate_all
    @query = params[:query_products]
    @products = Product.where('name LIKE ?', "%#{@query}%").update(active: true)
    redirect_to products_path(query_products: @query), notice: t('.product_success')
  end

  private

  def favorite_option(product)
    @favorite = Favorite.new
    return unless user_signed_in? && current_user.favorite_products.include?(product)

    @favorite = current_user.favorites.find { |fav| fav.product_id == product.id }
  end

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
