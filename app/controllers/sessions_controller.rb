class SessionsController < Devise::SessionsController
  def create
    super
    return unless current_user.common?

    begin
      response_card = Faraday.get("http://localhost:4000/api/v1/cards/#{current_user.cpf}")
    rescue StandardError
      return flash[:notice] = t('.api_error')
    end

    response_tratament(response_card)
  end

  def destroy
    super
    return unless @cart

    @cart.destroy!
  end

  private

  def response_tratament(response)
    create_user_card(response) if response.status == 200
    flash[:notice] = t('.error') if response.status == 404
  end

  def create_user_card(response)
    @data = JSON.parse(response.body)
    if current_user.card_info.present?
      current_user.card_info.update!(user: current_user, conversion_tax: @data['conversion_tax'],
                     name: @data['name'], status: @data['status'], points: @data['points'])
    else
      CardInfo.create!(user: current_user, conversion_tax: @data['conversion_tax'],
                       name: @data['name'], status: @data['status'], points: @data['points'])
    end
    flash[:notice] = t('.sucess_active')
  end
end
