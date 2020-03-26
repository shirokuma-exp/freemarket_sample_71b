class AddBuyerIdToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :buyer_id, :integer, :after => :user_id
  end
end
