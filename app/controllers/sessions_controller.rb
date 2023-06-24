class SessionsController < Devise::SessionsController
  def create
    super
    return unless current_user.common?

    begin
      response_card = current_user.find_card
    rescue StandardError
      return flash[:notice] = t('.api_error')
    end

    response_treatment(response_card)
  end

  def destroy
    super
    return unless @cart

    @cart.destroy!
  end

  private

  def response_treatment(response)
    create_user_card(response) if response.status == 200
    flash[:notice] = t('.error') if response.status == 404
  end

  def create_user_card(response)
    @data = JSON.parse(response.body)
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
