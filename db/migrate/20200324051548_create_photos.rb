class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.text :image 
      t.integer :item_id, null: false
      t.timestamps
    end
  end
end