class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :condition
  belongs_to_active_hash :delivery_charge
  belongs_to_active_hash :delivery_way
  belongs_to_active_hash :shipping_period
  belongs_to_active_hash :prefecture
  belongs_to_active_hash :region

  validates_associated :photos
  validates :name, :description, :condition_id, :size, :delivery_charge_id, :delivery_way_id, :shipping_period_id, :price, :region_id, :user_id, :category_id, presence: true
  validates :photos, presence: true
  # belongs_to :buyer, class_name: "User"
  belongs_to :user
  has_many :photos
  belongs_to :category, optional: true
    # validates :category, presence: { message: 'カテゴリーを選択してください' }

  # belongs_to :brand
  has_many :comments
  accepts_nested_attributes_for :photos, allow_destroy: true
  scope :searches, -> (search){where('name LIKE(?)', "%#{search}%")}
end
