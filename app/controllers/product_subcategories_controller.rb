class ProductSubcategoriesController < ApplicationController
  before_action :set_category, only: %i[new create subcategories]
  before_action :authenticate_user!, only: %i[index new create]
  before_action :check_user, only: %i[index new create]

  def index
    @product_subcategories = ProductSubcategory.all
  end

  def new
    @product_subcategory = ProductSubcategory.new
  end

  def create
    subcategory_params = params.require(:product_subcategory).permit(
      :name, :parent_id
    )

    @product_subcategory = ProductSubcategory.new(subcategory_params)

    if @product_subcategory.save
      redirect_to product_subcategories_path, notice: t('.success')
    else
      flash.now[:alert] = t('.error')
      render :new
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
