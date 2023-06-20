class SessionsController < Devise::SessionsController
  def create
    super

    response = Faraday.get("http://localhost:3333/api/v1/cards/#{current_user.cpf}")

    if response.status == 200
      @data = JSON.parse(response.body)
      @conversion_tax = @data[:conversion_tax]
    end
  end
end