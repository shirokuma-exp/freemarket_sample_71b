class ItemsController < ApplicationController
  require 'payjp'
  before_action :set_item,only: [:edit, :show, :update, :destroy, :purchase, :pay]
  before_action :move_to_index, except: [:index, :show, :new]
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :move_to_index, except: [:index, :show]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :set_card,only: [:purchase, :pay]
  before_action :correct_buyer,only: [:purchase, :pay]
  before_action :set_search

  def index
    @items = Item.includes(:photos).page(params[:page]).order("created_at DESC").per(10)
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
      redirect_to user_session_path
      flash[:alert] = 'ログインしてください。'
    end
  end

  def create
    @item = Item.new(item_params)
    @category_parent_array = Category.where(ancestry: nil).pluck(:name)
    respond_to do |format|
      if @item.save
        @item.update(status: 1)
        params[:item][:photos_attributes].each do |image|

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

  def update
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
      flash[:notice] = "商品の情報を更新しました"
    else 
      render :edit
      flash[:notice] = "情報の更新に失敗しました"
    end
    
  end

  def destroy
    if @item.destroy
      redirect_to root_path, notice: '商品を削除しました'
    else
      redirect_to item_path(@item)
    end
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
    params.require(:item).permit(:name, :description, :category_id, :brand_name, :condition_id, :size,
                                 :delivery_charge_id, :delivery_way_id, :region_id, :shipping_period_id,
                                 :price, :status, photos_attributes: [:image, :_destroy, :id]).merge(user_id: current_user.id)
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
  
  def correct_buyer
    unless @item.status == 1
      redirect_to action: :index
    end
  end

  def ensure_correct_user
    if @current_user.id !=  @item.user_id
     redirect_to root_path
    end
  end

end


