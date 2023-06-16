class ProductSubcategoriesController < ApplicationController
  before_action :set_category, only: %i[new create edit update subcategories]
  before_action :authenticate_user!, only: %i[new create edit update]
  before_action :check_user, only: %i[new create edit update]

  def new
    @product_subcategory = ProductSubcategory.new
  end

  def edit
    @product_subcategory = ProductSubcategory.find(params[:id])
  end

  def create
    subcategory_params = params.require(:product_subcategory).permit(
      :name, :parent_id
    )

    @product_subcategory = ProductSubcategory.new(subcategory_params)

    if @product_subcategory.save
      redirect_to product_categories_path, notice: t('.success')
    else
      flash.now[:alert] = t('.error')
      render :new
    end
  end

  def update
    subcategory_params = params.require(:product_subcategory).permit(
      :name, :parent_id
    )

    @product_subcategory = ProductSubcategory.find(params[:id])

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

  def set_category
    @categories = ProductCategory.where(parent_id: nil)
  end
end
