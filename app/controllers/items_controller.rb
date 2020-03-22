class ItemsController < ApplicationController

  def index
  end

  def new
    @item = Item.new
    @item.images.new
    @category = Category.all.order("id ASC").limit(13)
    @category_parent_array = Category.where(ancestry: nil).pluck(:name)
  end

  def get_category_children
    @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to :root
    else
      @category = Category.all.order("id ASC").limit(13)
      @category_parent_array = Category.where(ancestry: nil).pluck(:name)
      @item.images.new
      redirect_to new_item_path(current_user), flash: { error: @item.errors.full_messages }
    end
  end

  def show
    @item = Item.find(params[:id])
    @category = Category.find(@item.category_id)
  end

  def purchase
    @card = Card.where(user_id: current_user.id).first
    @item = Item.find(params[:id])
    Payjp.api_key= ENV["PAYJP_PRIVATE_KEY"]
    charge = Payjp::Charge.create(
      amount: @item.price,
      customer: Payjp::Customer.retrieve(@card.customer_id),
      currency: 'jpy'
    )
    @item_buyer= Item.find(params[:id])
    @item_buyer.update(buyer_id: current_user.id)
    redirect_to purchased_item_path
  end

end
