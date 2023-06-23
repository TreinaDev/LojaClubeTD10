class RegistrationsController < Devise::RegistrationsController
  def sign_up(resource_name, resource)
    super
    return unless current_user.common?

    begin
      response_company = current_user.verify_cpf_company
      response_company_tratament(response_company)
      response_card = current_user.find_card if response_company.status == 200
    rescue StandardError
      flash[:notice] = t('.api_error')
    end
  end

  private

  def response_company_tratament(response)
    data = JSON.parse(response.body)[0]
    session[:status_user] = data.blank? ? 'visitor' : data['status']
  end
end
