class SessionsController < Devise::SessionsController
  def create
    super
    
    response = Faraday.get("http://localhost:4000/api/v1/cards/#{current_user.cpf}")
    if response.status == 200
      @data = JSON.parse(response.body)
      session[:card_data] = @data
      flash[:notice] = 'Você tem cartão vinculado, seja bem vindo!'
    elsif response.status == 404
      flash[:alert] = 'Você não tem cartão vinculado.'
    end
  end
end
