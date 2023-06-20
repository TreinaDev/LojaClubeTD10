class SessionsController < Devise::SessionsController
  def create
    super

    response = Faraday.get("http://localhost:4000/api/v1/cards/#{current_user.cpf}")
    return unless response.status == 200

    @data = JSON.parse(response.body)
    session[:card_data] = @data
  end

  def destroy
    super
    return unless @cart

    @cart.destroy!
  end
end
