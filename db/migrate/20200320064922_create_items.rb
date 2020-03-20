class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name,            null: false
      t.text :description,       null: false
      t.string :condition,       null: false
      t.string :size,            null: false
      t.string :delivery_charge, null: false
      t.string :delivery_way,    null: false
      t.string :shipping_period, null: false
      t.integer :price,          null: false
      t.integer :like,           null: false
      t.string :region,          null: false
      t.references :user,        foreign_key: true
      t.integer :category_id
      t.integer :brand_id
      t.timestamps
    end
  end
end
