class RegistrationsController < Devise::RegistrationsController
  def sign_up(resource_name, resource)
    super
    return unless current_user.common?

    begin
      response_company = current_user.verify_cpf_company
      response_company_treatment(response_company)
      response_card_treatment(current_user.find_card) if response_company.status == 200
    rescue StandardError
      flash[:notice] = t('.api_error')
      session[:status_user] = 'visitor'
    end
  end

  private

  def response_company_treatment(response)
    data = JSON.parse(response.body)[0] if response.status == 200
    session[:status_user] = data.blank? ? 'visitor' : data['status']
    session[:company_cnpj] = data['company_cnpj'] if data.present?
  end

  def response_card_treatment(response)
    create_user_card(response) if response.status == 200
    flash[:notice] = t('.error') if response.status == 404
  end

  def create_user_card(response)
    @data = JSON.parse(response.body)
    flash[:notice] = t('.success_active')
    CardInfo.create!(user: current_user, conversion_tax: @data['conversion_tax'],
                     name: @data['name'], status: @data['status'], points: @data['points'])
  end
end
