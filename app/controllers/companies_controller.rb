class CompaniesController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  before_action :check_user, only: %i[index]

  def index
    bring_companies
    @companies_active = Company.where(active: true).order(:brand_name)
    @companies_inactive = Company.where(active: false).order(:brand_name)
  end
end
