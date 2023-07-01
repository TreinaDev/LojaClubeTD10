class ProductCategoriesController < ApplicationController
  before_action :set_product_category, only: %i[edit update deactivate reactivate]
  before_action :authenticate_user!, only: %i[index new edit create update deactivate reactivate]
  before_action :check_user, only: %i[index new edit create update deactivate reactivate]

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
      redirect_to product_categories_path, notice: t('.create.success')
    else
      flash.now[:alert] = t('.create.error')
      render :new
    end
  end

  def update
    if @product_category.update(product_category_params)
      redirect_to product_categories_path, notice: t('.update.success')
    else
      flash.now[:alert] = t('.update.error')
      render :edit
    end
  end

  def search
    product_category = ProductCategory.find(params[:products_category])
    @products = Product.where(product_category:, active: true).order(created_at: :desc).to_a
    @products_sub_categories = product_category.subcategories.map(&:products).flatten
    @products.concat(@products_sub_categories)

    @quantity = @products.length
  end

  def deactivate
    @product_category.update(active: false)
    redirect_to product_categories_path, notice: t('.deactivate.success')
  end

  def reactivate
    @product_category.update(active: true)
    redirect_to product_categories_path, notice: t('.reactivate.success')
  end

  private

  def set_product_category
    @product_category = ProductCategory.find(params[:id])
  end

  def product_category_params
    params.require(:product_category).permit(:name, :status)
  end

  def check_user
    return if current_user.admin?

    redirect_to root_path, alert: t('access_denied')
  end
end
