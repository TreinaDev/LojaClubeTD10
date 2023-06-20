class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    conversion_tax = 20.7
    @order = Order.new(order_params, conversion_tax: conversion_tax)
    @order.user_id = current_user.id
    if @order.save
      return redirect_to root_path, notice: 'Seu pedido foi realizado com sucesso!'
    end
    render :new
  end

  private

  def order_params
    params
    .require(:order)
    .permit(:order_number, :total_value, :discount_amount, :final_value, :cpf, :card_number, :payment_date, :user_id, :shopping_cart_id)
  end

end
