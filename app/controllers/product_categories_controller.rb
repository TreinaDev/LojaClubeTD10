class ProductCategoriesController < ApplicationController
  before_action :set_product_category, only: %i[edit update]

  def index
    @product_categories = ProductCategory.all
  end

  def new
    @product_category = ProductCategory.new
  end

  def edit; end

  def create
    @product_category = ProductCategory.new(product_category_params)
    if @product_category.save
      redirect_to product_categories_path, notice: t('product_category.create.success')
    else
      flash.now[:alert] = t('product_category.create.error')
      render :new
    end
  end

  def update
    if @product_category.update(product_category_params)
      redirect_to product_categories_path, notice: t('product_category.update.success')
    else
      flash.now[:alert] = t('product_category.update.error')
      render :edit
    end
  end

  private

  def set_product_category
    @product_category = ProductCategory.find(params[:id])
  end

  def product_category_params
    params.require(:product_category).permit(:name)
  end
end
