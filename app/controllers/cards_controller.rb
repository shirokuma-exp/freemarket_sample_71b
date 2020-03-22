class CardsController < ApplicationController
  before_action :authenticate_user!
  require "payjp"

  def index
    # @card = CreditCard.where(user_id: current_user.id)
    @card = Card.where(user_id: current_user.id)
    if @card.present?
      # @card = CreditCard.where(user_id: current_user.id).first
      @card = Card.where(user_id: current_user.id)
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      customer = Payjp::Customer.retrieve(@card.customer_id)
      @default_card_information = customer.cards.retrieve(@card.card_id)
    else
      redirect_to action: "new" 
    end
  end

  def new
    # @card = CreditCard.where(user_id: current_user.id)
    @card = Card.where(user_id: current_user.id)
    redirect_to action: "index" if @card.exists?
  end

  def pay
    Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
    if params['payjp-token'].blank?
      redirect_to action: "new"
    else
      customer = Payjp::Customer.create(
      card: params['payjp-token'],
      metadata: {user_id: current_user.id}
      )
      # @credit_card = CreditCard.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
      @card = Card.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        redirect_to action: "index"
        flash[:notice] = 'クレジットカードの登録が完了しました'
      else
        redirect_to action: "pay"
        flash[:alert] = 'クレジットカード登録に失敗しました'
      end
    end
  end

  def show
    # @card = CreditCard.where(user_id: current_user.id)
    @card = Card.where(user_id: current_user.id)
    if @card.blank?
      redirect_to action: "new" 
      flash[:touroku] = '商品の購入には、クレジットカードの登録が必要となります。'
    else
      # @card = CreditCard.where(user_id: current_user.id).first
      @card = Card.where(user_id: current_user.id).first
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      customer = Payjp::Customer.retrieve(@card.customer_id)
      @default_card_information = customer.cards.retrieve(@card.card_id)
      @destination = Destination.where(user_id: current_user.id).first
      @user = current_user
      
    end
  end

  def buy
    @user = current_user
    @image = @item.images.includes(:item)
    # @card = Creditcard.where(user_id: current_user.id).first
    @card = Card.where(user_id: current_user.id).first
    @address = Address.where(user_id: current_user.id).first
    @item = item.find(params[:id])
    #Payjpの秘密鍵を取得
    Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
    #Payjpから顧客情報を取得し、表示
    customer = Payjp::Customer.retrieve(@card.customer_id)
    @creditcard_information = customer.cards.retrieve(@card.card_id)

  end


  def delete #PayjpとCreditCardデータベースを削除
    # @credit_card = CreditCard.where(user_id: current_user.id).first
    @card = Card.where(user_id: current_user.id).first
    if @card.blank?
    else
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      customer = Payjp::Customer.retrieve(@card.customer_id)
      customer.delete
      @card.delete
    end
      redirect_to action: "new"
  end
end
