class ItemsController < ApplicationController
  require 'payjp'
  before_action :set_card,only: [:purchase, :pay]
 
  def purchase
    # @item = Item.find(params[:item_id])
    if @cards.blank?
      redirect_to controller: "cards", action: "new"
    else
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      customer = Payjp::Customer.retrieve(card.customer_id)
      @default_card_information = customer.cards.retrieve(card.card_id)
    end
  end

  def pay
    # item = Item.find(params[:item_id])
    # item.update(buyer_id: current_user.id)
    Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
    Payjp::Charge.create(
    :amount => item.price, 
    :customer => card.customer_id, 
    :currency => 'jpy', 
    )
    redirect_to action: 'done' 
  end

  def done
  end

  def index
  end

  def set_card
    @cards = Card.where(user_id: current_user.id).first
  end
  
  def new
  end

  def show
  end

end
