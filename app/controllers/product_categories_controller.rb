class ProductCategoriesController < ApplicationController
  before_action :set_product_category, only: %i[edit update deactivate reactivate]
  before_action :authenticate_user!, only: %i[index new edit create update deactivate reactivate]
  before_action :check_user, only: %i[index new edit create update deactivate reactivate]
  before_action :add_index_breadcrumb, only: %i[new edit create update]

  def index
    add_breadcrumb('Categorias de Produtos')
    @product_categories = ProductCategory.all
  end

  def new
    add_breadcrumb('Nova Categoria')
    @product_category = ProductCategory.new
  end

  def edit
    add_breadcrumb("Editar #{@product_category.name}")
  end

  def create
    add_breadcrumb('Nova Categoria')

    @product_category = ProductCategory.new(product_category_params)
    if @product_category.save
      redirect_to product_categories_path, notice: t('product_category.create.success')
    else
      flash.now[:alert] = t('product_category.create.error')
      render :new
    end
  end

  def update
    add_breadcrumb("Editar #{@product_category.name}")

    if @product_category.update(product_category_params)
      redirect_to product_categories_path, notice: t('product_category.update.success')
    else
      flash.now[:alert] = t('product_category.update.error')
      render :edit
    end
  end

  def deactivate
    @product_category.update(active: false)
    redirect_to product_categories_path, notice: t('product_category.deactivate.success')
  end

  def reactivate
    @product_category.update(active: true)
    redirect_to product_categories_path, notice: t('product_category.reactivate.success')
  end

  private

  def add_index_breadcrumb
    add_breadcrumb('Categorias de Produtos', product_categories_path)
  end

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
