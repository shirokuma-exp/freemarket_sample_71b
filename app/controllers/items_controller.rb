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
    @items = Item.all.page(params[:page]).order("created_at DESC").per(10)
    @photos = Photo.all
  end

  def set_card
    @cards = Card.where(user_id: current_user.id).first
  end
  
  def new
    @item = Item.new
    @user = current_user.id
    @item.photos.build
  end
  
  def create
    @item = Item.new(item_params)
    respond_to do |format|
      if @item.save
          params[:photos][:image].each do |image|
            @item.photos.create(image: image, item_id: @item.id)
          end
        format.html{redirect_to root_path}
      else
        @item.photos.build
        format.html{render action: 'new'}
      end
    end
  end



  # def create
  #   @item = Item.new(item_params)

  #   if @item.save
  #     redirect_to root_path
  #   else
  #     render :new
  #   end
  # end

  def show
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :category_id, :brand, :condition_id, :size, :delivery_charge_id, :delivery_way_id, :region_id, :shipping_period_id, :price, item_images_attributes: [:image]).merge(user_id: current_user.id)
  end

end


