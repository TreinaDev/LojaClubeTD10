class SessionsController < Devise::SessionsController
  def create
    super
    return unless current_user.common?

    begin
      response = Faraday.get("http://localhost:4000/api/v1/cards/#{current_user.cpf}")
    rescue
      return flash[:notice] = t('.api_error')
    end

    response_tratament(response)
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
    CardInfo.create!(user: current_user, conversion_tax: @data['conversion_tax'],
                     name: @data['name'], status: @data['status'], points: @data['points'])
    flash[:notice] = if @data['status'] == 'active'
                       t('.sucess_active')
                     else
                       t('.sucess_inactive')
                     end
  end
end
