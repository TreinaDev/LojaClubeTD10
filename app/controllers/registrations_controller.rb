class RegistrationsController < Devise::RegistrationsController
  def create
    begin
      response = Faraday.get("http://localhost:3000/api/v1/employee_profiles?cpf=#{params[:user][:cpf]}")
      @employee_response = JSON.parse(response.body)
      if !@employee_response.blank?
        super 
      else  
        flash.now[:notice] = 'Nao foi possivel fazer login'
        redirect_to root_path
      end
    rescue StandardError
      flash[:notice] = 'Nao foi possivel fazer login'
    end
  end

  def sign_up(resource_name, resource)
    super
    return unless current_user.common?

    begin
      response_card = Faraday.get("http://localhost:4000/api/v1/cards/#{current_user.cpf}")
      @data = response.body
    rescue StandardError
      return flash[:notice] = t('.api_error')
    end

    response_tratament(response_card)
  end

  private

  def response_tratament(response)
    create_user_card(response) if response.status == 200
    flash[:notice] = t('.error') if response.status == 404
  end

  def create_user_card(response)
    @data = JSON.parse(response.body)
    flash[:notice] = t('.sucess_active')
    CardInfo.create!(user: current_user, conversion_tax: @data['conversion_tax'],
                     name: @data['name'], status: @data['status'], points: @data['points'])
  end
end
