class CardsController < ApplicationController
  require "payjp"
  before_action :set_card,only: [:show,:delete]

  def new
    @user = User.find(params[:user_id])
    card = Card.where(user_id: current_user.id)
    redirect_to action: "show" if card.exists?
  end

  def pay
    @user = User.find(params[:user_id])
    Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
    if params['payjp-token'].blank?
      redirect_to action: "new"
    else
      customer = Payjp::Customer.create(
      description: '登録テスト', 
      email: current_user.email, 
      card: params['payjp-token'],
      metadata: {user_id: current_user.id}
      ) 
      @card = Card.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        redirect_to action: "show"
        flash[:success] = '登録に成功しました'
      else
        redirect_to action: "pay"
        flash[:alart] = '登録に失敗しました'
      end
    end
  end
  
  def delete
    @user = User.find(params[:user_id])
    unless @cards.blank?
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      customer = Payjp::Customer.retrieve(@cards.customer_id)
      customer.delete
      @cards.delete
    end
      redirect_to controller: "cards", action: "new"
      flash[:success] = '登録を削除しました'
  end

  def show
    @user = User.find(params[:user_id])
    if @cards.blank?
      redirect_to controller: "cards", action: "new"
    else
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      customer = Payjp::Customer.retrieve(@cards.customer_id)
      @default_card_information = customer.cards.retrieve(@cards.card_id)
    end
  end

  private
  def set_card
    @cards = Card.where(user_id: current_user.id).first
  end
end
