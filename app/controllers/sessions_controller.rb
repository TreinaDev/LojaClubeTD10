class SessionsController < Devise::SessionsController
  def destroy
    super
    return unless @cart

    @cart.destroy!
  end
end
