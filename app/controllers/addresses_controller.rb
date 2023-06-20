class AddressesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :prevent_admin, only: %i[new create edit update destroy]

  def new
    @address = Address.new
  end

  def edit
    @address = Address.find(params[:id])
  end

  def create
    @address = Address.new(addresses_params)

    if @address.save
      ClientAddress.create(user: current_user, address: @address)

      return redirect_to client_addresses_path, notice: t('.success')
    end

    flash.now[:alert] = t('.error')
    render :new
  end

  def update
    @address = Address.find(params[:id])

    if @address.update(addresses_params)
      redirect_to client_addresses_path, notice: t('.success')
    else
      flash.now[:alert] = t('.error')
      render :edit
    end
  end

  def set_default
    @address = Address.find(params[:id])
    @user = current_user

    ClientAddress.transaction do
      @user.client_addresses.each do |client_address|
        client_address.update(default: client_address.address == @address)
      end
    end

    redirect_to client_addresses_path, notice: t('.success')
  end

  def destroy
    @user = current_user
    @address = @user.addresses.find(params[:id])
    @address.destroy

    redirect_to client_addresses_path, notice: t('.success')
  end

  private

  def addresses_params
    params
      .require(:address)
      .permit(:address, :number, :city, :state, :zipcode, :submit_text)
  end
end
