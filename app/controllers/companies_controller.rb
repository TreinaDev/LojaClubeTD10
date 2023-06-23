class CompaniesController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  before_action :check_user, only: %i[index]

  def index
    @companies_active = Company.where(active: true).order(:brand_name)
    @companies_inactive = Company.where(active: false).order(:brand_name)
    begin
      response = Faraday.get('http://localhost:3000/api/v1/companies')
      response_tratament(response)
      @companies_count_after = Company.count
      flash.now[:alert] = t('.no_company_added') if @companies_count_before == @companies_count_after
    rescue Faraday::ConnectionFailed
      flash.now[:alert] = t('.api_error')
    end
  end

  private

  def response_tratament(response)
    if response.status == 500
      flash.now[:alert] = t('.internal_error')
      render :index
    end
    iterates_companies(response) if response.status == 200
  end

  def iterates_companies(response)
    @companies_count_before = Company.count
    @companies_api = JSON.parse(response.body)
    @companies_api.each do |cia|
      company = Company.find_by(registration_number: cia['registration_number'])

      unless cia['active'].nil?
        company.nil? ? create(cia) : update(cia)
      end
    end
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
end
