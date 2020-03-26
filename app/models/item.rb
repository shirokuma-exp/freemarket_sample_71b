class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :condition
  belongs_to_active_hash :delivery_charge
  belongs_to_active_hash :delivery_way
  belongs_to_active_hash :shipping_period
  belongs_to_active_hash :prefecture
  belongs_to_active_hash :region

  
  belongs_to :user
  has_many :photos
  belongs_to :category, optional: true
    validates :category, presence: { message: 'カテゴリーを選択してください' }
  has_many :comments
  accepts_nested_attributes_for :photos
end
