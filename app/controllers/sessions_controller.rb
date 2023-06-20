class SessionsController < Devise::SessionsController
  def create
    super
    return unless current_user.common?

    response = Faraday.get("http://localhost:4000/api/v1/cards/#{current_user.cpf}")

    response_tratament(response)
  end

  def destroy
    super
    return unless @cart

    @cart.destroy!
  end

  private

  def response_tratament(response)
    create_session(response) if response.status == 200
    flash[:notice] = t('.error') if response.status == 404
  end

  def create_session(response)
    @data = JSON.parse(response.body)
    if @data['status'] == 'active'
      flash[:notice] = t('.sucess_active')
      session[:card_data] = @data
    else
      flash[:notice] = t('.sucess_inactive')
    end
  end
end
