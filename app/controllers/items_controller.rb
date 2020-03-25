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
    @items = Item.all.order("id DESC").page(params[:page]).per(3)
  end

  def set_card
    @cards = Card.where(user_id: current_user.id).first
  end
  
  def new
    @category_parent_array = ["---"]
    Category.where(ancestry: nil).each do |parent|
      @category_parent_array << parent.name
    end
  end

  def get_category_children
    @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end

  def create
    @item = Item.new(item_params)
    @category_parent_array = Category.where(ancestry: nil).pluck(:name)

    if @item.save
      redirect_to root_path
    else
      @category_parent_array = Category.where(ancestry: nil).pluck(:name)
      @item.images.new
      render :new
    end
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
    else 
      render :edit
    end
  end

  def show
  end

  def item_params
    params.require(:item).permit(:category_id)
  end

end
