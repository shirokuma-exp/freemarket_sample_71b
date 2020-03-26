class CategoriesController < ApplicationController
  def index
    @parents = Category.all.order("id ASC").limit(13)
  end
 
  def new
  end

  def show
      @category = Category.find(params[:id])
      if @category.has_children? && @category.has_parent?
          @categories = @category.children
          @category_ids = @category.child_ids
          @item = Item.where(category: @category_ids).order("created_at DESC").page(params[:page]).per(20)
      elsif @category.is_childless? 
          @category_ids = @category.sibling_ids
          @categories = Category.find(@category_ids)
          @item = @category.products.order("created_at DESC").page(params[:page]).per(20)
      else
          @categories = @category.children
          @category_ids = @category.indirect_ids
          @item = Item.where(category: @category_ids).order("created_at DESC").page(params[:page]).per(20)
      end
  end
end
