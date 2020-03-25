class Address < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture
  belongs_to :user
  validates :destination, :destination_kana, :postcode, :prefecture_id, :city, :street, presence: true
end