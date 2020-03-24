class ChangeItemsDataType < ActiveRecord::Migration[5.2]
  def change
    remove_column :items, :condition,          :string
    add_column    :items, :condition_id,       :integer, null: false, :after => :description
    remove_column :items, :delivery_charge,    :string
    add_column    :items, :delivery_charge_id, :integer, null: false, :after => :size
    remove_column :items, :delivery_way,       :string
    add_column    :items, :delivery_way_id,    :integer, null: false, :after => :delivery_charge_id
    remove_column :items, :shipping_period,    :string
    add_column    :items, :shipping_period_id, :integer, null: false, :after => :delivery_way_id
    remove_column :items, :region,             :string
    add_column    :items, :region_id,          :integer, null: false, :after => :shipping_period_id
  end
end
