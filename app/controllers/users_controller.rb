class UsersController < ApplicationController
  before_action :set_search

  def edit
  end
  
  def update
  end  

  def set_search
    @search = Item.ransack(params[:q]) 
    @search_items = @search.result(distinct: true)
  end
end
