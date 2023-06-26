class HomeController < ApplicationController
  def index
    @products = Product.order(created_at: :desc).filter { |p| p.product_category.active? }

    @campaign_products = []
    
    cnpj = session[:company_cnpj]
    company = Company.find_by(registration_number: cnpj)
    if company&.promotional_campaigns.present?
      company.promotional_campaigns.each do |campaign|
        campaign.campaign_categories.each do |category|
          @campaign_products << category.product_category.products
        end
      end
    end
  end
end
