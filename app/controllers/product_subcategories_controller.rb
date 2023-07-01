class ProductSubcategoriesController < ApplicationController
  before_action :set_category, only: %i[new create edit update subcategories]
  before_action :authenticate_user!, only: %i[new create edit update]
  before_action :check_user, only: %i[new create edit update]
  before_action :add_index_breadcrumb, only: %i[new edit create update]

  def new
    add_breadcrumb('Nova Subcategoria')
    @product_subcategory = ProductSubcategory.new
  end

  def edit
    @product_subcategory = ProductSubcategory.find(params[:id])
    add_breadcrumb("Editar #{@product_subcategory.name}")
  end

  def create
    add_breadcrumb('Nova Subcategoria')
    @product_subcategory = ProductSubcategory.new(subcategory_params)

    if @product_subcategory.save
      redirect_to product_categories_path, notice: t('.success')
    else
      flash.now[:alert] = t('.error')
      render :new
    end
  end

  def update
    @product_subcategory = ProductSubcategory.find(params[:id])
    add_breadcrumb("Editar #{@product_subcategory.name}")

    if @product_subcategory.update(subcategory_params)
      redirect_to product_categories_path, notice: t('.success')
    else
      flash.now[:alert] = t('.error')
      render :edit
    end
  end

  def subcategories
    @product_category = ProductCategory.find(params[:id])
    @subcategories = @product_category.subcategories

    render json: @subcategories
  end

  private

  def add_index_breadcrumb
    add_breadcrumb('Categorias de Produtos', product_categories_path)
  end

  def set_category
    @categories = ProductCategory.where(parent_id: nil, active: true)
  end

  def subcategory_params
    params.require(:product_subcategory).permit(:name, :parent_id)
  end
end
