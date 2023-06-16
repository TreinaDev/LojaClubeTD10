class SessionsController < Devise::SessionsController
  before_action :clear_cart, only: :destroy

  private

  def clear_cart
    if @cart
      @cart.destroy!
    end
  end
end