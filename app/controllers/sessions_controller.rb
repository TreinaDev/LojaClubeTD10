class SessionsController < Devise::SessionsController
  def create
    super

    response = Faraday.get("http://localhost:4000/api/v1/cards/#{current_user.cpf}")

    case response.status
    when 200
      @data = JSON.parse(response.body)
      if @data['status'] == 'active' 
        flash[:notice] = 'Logado com sucesso. O seu cartão está ativo, vamos às compras.'
        session[:card_data] = @data
      else
        flash[:notice] = 'Logado com sucesso. O seu cartão não está ativo, entre em contato com sua empresa.'
      end
    when 404
      flash[:notice] = 'Logado com sucesso. Você não tem cartão ativo no nosso clube!'
    end
  end

  def destroy
    super
    return unless @cart

    @cart.destroy!
  end
end
