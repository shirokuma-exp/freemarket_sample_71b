# freemarket_sanmple_71b DB設計
## usersテーブル
|Column|Type|Options|
|------|----|-------|
|nickname|string|null: false|
|email|string|null: false|
|encrypted_password|string|null: false|
|name|string|null: false|
|name_kana|string|null: false|
|birthday|date|null: false|
|phone_number|integer|null: false|
|sex|string|null: false|
### Association
- has_many :items
- has_many :comments
- has_one :card
- has_one :address

## addressesテーブル
|Column|Type|Options|
|------|----|-------|
|destination|string|null: false|
|destination_kana|string|null: false|
|postcode|integer|null: false|
|prefecture|string|null: false|
|city|string|null: false|
|street|string|null: false|
|building|string|null: false|
|user_id|string|null: false, foreign_key: true|
### Association
- belongs_to :user

## itemsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|description|text|null: false|
|condition_id|integer(ah)|null: false|
|size|string|null: false|
|delivery_charge_id|integer(ah)|null: false|
|delivery_way_id|integer(ah)|null: false|
|shipping_period_id|integer(ah)|null: false|
|price|integer|null: false|
|like|integer||
|region_id|integer(ah)|null: false|
|user_id|integer|null: false, foreign_key: true|
|buyer_id|integer||
|status|integer||
|category_id|integer|null: false, foreign_key: true|
|brand_id|integer|null: false, foreign_key: true|
### Association
- belongs_to :user
- has_many :photos
- belongs_to :category
- belongs_to :brand
- has_many :comments

## photosテーブル
|Column|Type|Options|
|------|----|-------|
|image|text|null: false|
|item_id|integer|null: false, foreign_key: true|
### Association
- belongs_to :item

## categoriesテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|ancestry|stirng||
### Association
- has_many :items
- has_ancestry

## brandsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string||
### Association
- has_many :items

## cardsテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|string|null: false, foreign_key: true|
|customer_id|string|null: false|
|card_id|string|null: false|
### Association
- belongs_to :user

## commentsテーブル
|Column|Type|Options|
|------|----|-------|
|text|string|null: false|
|user_id|integer|null: false, foreign_key: true|
|item_id|integer|null: false, foreign_key: true|
- belongs_to :item
- belongs_to :user