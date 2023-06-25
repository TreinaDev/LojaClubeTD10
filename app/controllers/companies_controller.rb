class CompaniesController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  before_action :check_user, only: %i[index]

  def index
    @companies = Company.order(:brand_name)
    @companies_active = @companies.where(active: true)
    @companies_inactive = @companies.where(active: false)
    begin
      response = Faraday.get('http://localhost:3000/api/v1/companies')
      response_tratament(response)
    rescue StandardError
      flash.now[:alert] = t('.internal_error')
    end
  end

  def response_tratament(response)
    case response.status
    when 200
      iterates_companies(response)
      flash_notice
    when 204
      flash.now[:notice] = t('.sucess_no_company')
    else
      flash.now[:alert] = t('.internal_error')
    end
  end

  def iterates_companies(response)
    @companies_count_before = Company.count
    companies_api = JSON.parse(response.body)
    companies_api.each do |cia|
      company = Company.find_by(registration_number: cia['registration_number'])

      unless cia['active'].nil?
        company.nil? ? create(cia) : update(cia)
      end
    end
    @companies_count_after = Company.count
  end

  def create(cia)
    Company.new(registration_number: cia['registration_number'],
                brand_name: cia['brand_name'],
                corporate_name: cia['corporate_name'],
                active: cia['active']).save
  end

  def update(cia)
    Company.find_by(registration_number: cia['registration_number']).update(brand_name: cia['brand_name'],
                                                                            corporate_name: cia['corporate_name'],
                                                                            active: cia['active'])
  end

  def flash_notice
    flash.now[:notice] = if @companies_count_before == @companies_count_after
                           t('.sucess_no_company_added')
                         else
                           t('.sucess_new_company_added')
                         end
  end
end
