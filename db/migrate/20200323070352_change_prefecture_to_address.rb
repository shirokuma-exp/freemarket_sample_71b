class ChangePrefectureToAddress < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :prefecture_id, :integer, :after => :postcode
    remove_column :addresses, :prefecture, :string
  end
end
