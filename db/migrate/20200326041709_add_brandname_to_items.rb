class AddBrandnameToItems < ActiveRecord::Migration[5.2]
  def change
    add_column    :items, :brand_name, :string
    remove_column :items, :brand_id,   :integer, :after => :user_id
  end
end
