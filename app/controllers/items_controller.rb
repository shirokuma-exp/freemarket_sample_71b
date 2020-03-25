class ItemsController < ApplicationController

  def index
    @items = Item.all.page(params[:page]).order("created_at DESC").per(10)
    @photos = Photo.all
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


