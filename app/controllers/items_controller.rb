class ItemsController < ApplicationController
  require 'payjp'
  before_action :set_card,only: [:purchase, :pay]
  before_action :set_item,only: [:edit, :show, :purchase, :pay]
  before_action :move_to_index, except: [:index, :show]
  before_action :set_search

  def index
    @items = Item.all.page(params[:page]).order("created_at DESC").per(10)
    @photos = Photo.all
  end
  
  def new
    if user_signed_in?
      @item = Item.new
      @user = current_user.id
      @item.photos.new
        @category_parent_array = Category.where(ancestry: nil).pluck(:name)
        @category_parent_array.unshift("---")
    else
      redirect_to root_path
      flash[:alert] = 'ログインしてください。'
    end
  end

  def create
    @item = Item.new(item_params)
    @category_parent_array = Category.where(ancestry: nil).pluck(:name)
    respond_to do |format|
      if @item.save
        params[:photos][:image].each do |image|
        @item.photos.create(image: image, item_id: @item.id)
        end
        format.html{redirect_to root_path}
        format.json
      else
        @item.photos.build
        format.html{redirect_to new_item_path(@item), notice: '入力項目が不足しています'}
      end
    end
  end

  def get_category_children
    @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end

  def edit
    grandchild_category = @item.category
    child_category = grandchild_category.parent

    @category_parent_array = []
    Category.where(ancestry: nil).each do |parent|
      @category_parent_array << parent.name
    end

    @category_children_array = []
    Category.where(ancestry: child_category.ancestry).each do |children|
      @category_children_array << children
    end

    @category_grandchildren_array = []
    Category.where(ancestry: grandchild_category.ancestry).each do |grandchildren|
      @category_grandchildren_array << grandchildren
    end
  end

  def destroy
    @item = Item.find(params[:id])
    if @item.destroy
      redirect_to root_path, notice: '商品を削除しました'
    else
      redirect_to item_path(@item)
    end
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)

    grandchild_category = @item.category
    child_category = grandchild_category.parent
    @category_parent_array = []
    @category_parent_array = Category.where(ancestry: nil).pluck(:name)
    @category_children_array = []
    @category_children_array = Category.where(ancestry: child_category.ancestry)
    @category_grandchildren_array = []
    @category_grandchildren_array  = Category.where(ancestry: grandchild_category.ancestry)
    if @item.update(item_params)
      redirect_to item_path(@item)
    else 
      render :edit
    end
    
    @item.photos.new
  end
  
  def show
  end

  def purchase
    card = Card.find_by(user_id: current_user.id)
    if @cards.blank?
      redirect_to controller: "cards", action: "new", user_id: current_user.id
    else
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      customer = Payjp::Customer.retrieve(card.customer_id)
      @default_card_information = customer.cards.retrieve(card.card_id)
    end
  end

  def pay
    Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
    Payjp::Charge.create(
    :amount => @item.price, 
    :customer => @cards.customer_id, 
    :currency => 'jpy', 
    )
    @item_buyer= Item.find(params[:id])
    @item_buyer.update(buyer_id: current_user.id)
    @item.update(status: 0)
    redirect_to action: 'done' 
  end

  def done
  end

  def search
  end

  def set_search
    @search = Item.ransack(params[:q]) 
    @search_items = @search.result(distinct: true)
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :category_id, :brand_name, :condition_id, :size, :delivery_charge_id, :delivery_way_id, :region_id, :shipping_period_id, :price, :status, item_photos_attributes: [:image]).merge(user_id: current_user.id)
  end

  def set_card
    @cards = Card.where(user_id: current_user.id).first
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end

end


