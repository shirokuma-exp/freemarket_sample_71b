class ChangeLikeToItem < ActiveRecord::Migration[5.2]
  def change
    remove_column :items, :like, :integer, null: false
    add_column    :items, :like, :integer, :after => :price
  end
end
