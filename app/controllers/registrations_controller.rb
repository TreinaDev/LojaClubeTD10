class RegistrationsController < Devise::RegistrationsController
  def sign_up(resource_name, resource)
    super
    return unless current_user.common?

    begin
      response_company = current_user.verify_cpf_company
      response_company_tratament(response_company)
      if response_company.status == 200
        response_card = Faraday.get("http://localhost:4000/api/v1/cards/#{current_user.cpf}")
      end
    rescue StandardError
      return flash[:notice] = t('.api_error')
    end
  end

  private

  def response_company_tratament(response)
    data = JSON.parse(response.body)[0]
    if data.blank?
      session[:status_user] = 'visitor'
    else  
      session[:status_user] = data['status']
    end
  end
end
