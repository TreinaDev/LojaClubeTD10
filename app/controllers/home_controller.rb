class HomeController < ApplicationController
  def index
    if params[:product_category].blank?
      @products = Product.where(active: true).order(created_at: :desc)
    else
      product_category = params[:product_category]
      @products = Product.where(product_category_id: product_category, active: true).order(created_at: :desc)
    end

    set_campaigns
  end

  private

  def set_campaigns
    @campaigns = []

    cnpj = session[:company_cnpj]
    company = Company.find_by(registration_number: cnpj)
    return if company&.promotional_campaigns.blank?

    company.promotional_campaigns.each do |campaign|
      @campaigns << campaign if campaign.products.any?
    end
  end
end
