class AddressesController < ApplicationController
  def new
    @address = Address.new
    @user = User.find(params[:user_id])
  end

  def create
    @address = Address.new(address_params)
    if @address.save
      flash[:notice] = '登録が完了いたしました' 
      redirect_to root_path
    else
      # @address = address.postcode.includes(:address)
      # flash.now[:alert] = '必須項目を入力してください'
      # render new_user_address_path(current_user)
      flash[:alert] = '必須事項を再度入力してください。'
      redirect_to root_path
    end
  end
  
  # def create
  #   @message = @group.messages.new(message_params)
  #   if @message.save
  #     redirect_to group_messages_path(@group), notice: 'メッセージが送信されました'
  #   else
  #     @messages = @group.messages.includes(:user)
  #     flash.now[:alert] = 'メッセージを入力してください。'
  #     render :index
  #   end
  # end


  private
  def address_params
    params.require(:address).permit(:destination, :destination_kana, :postcode, :prefecture_id, :city, :street, :building).merge(user_id: current_user.id)
  end
end
