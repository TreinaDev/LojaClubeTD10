class SessionsController < Devise::SessionsController
  def create
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

  def destroy
    super
    return unless @cart

    @cart.destroy!
  end

  private

  def response_company_treatment(response)
    data = JSON.parse(response.body)[0]
    session[:status_user] = data.blank? ? 'visitor' : data['status']
  end

  def response_card_treatment(response)
    create_user_card(response) if response.status == 200
    return unless response.status == 404

    current_user.card_info&.destroy
    flash[:notice] = t('.error')
  end

  def create_user_card(response)
    @data = JSON.parse(response.body)
    return current_user.card_info&.destroy if @data['status'] != 'active'

    if current_user.card_info.present?
      update_card(@data)
    else
      create_card(@data)
    end
    flash[:notice] = t('.success_active')
  end

  def update_card(data)
    current_user.card_info.update!(user: current_user, conversion_tax: data['conversion_tax'],
                                   name: data['name'], status: data['status'], points: data['points'])
  end

  def create_card(data)
    CardInfo.create!(user: current_user, conversion_tax: data['conversion_tax'],
                     name: data['name'], status: data['status'], points: data['points'])
  end
end
