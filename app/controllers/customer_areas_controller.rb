class CustomerAreasController < ApplicationController
  before_action :authenticate_user!, only: %i[index me addresses]
  before_action :prevent_admin, only: %i[index me favorite_tab addresses]
  before_action :prevent_visitor, only: %i[favorite_tab addresses]

  def index; end

  def me
    @user = current_user
  end

  def addresses
    @user = current_user
  end

  def favorite_tab
    return unless user_signed_in?

    @user = current_user
    @favorites_active = Favorite.joins(:product)
                                .where(user: @user, products: { active: true })
    @favorites_inactive = Favorite.joins(:product)
                                  .where(user: @user, products: { active: false })
  end
end
