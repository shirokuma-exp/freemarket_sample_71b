require 'rails_helper'
describe Item do
  describe '#create' do

    # 1.user_idが空では登録できないこと
    it "is invalid without a user_id" do
      item = build(:item, user_id: "")
      item.valid?
      expect(item.errors[:user_id]).to include("can't be blank")
    end

    # 2.nameが空では登録できないこと
    it "is invalid without a name" do
      item = build(:item, name: "")
      item.valid?
      expect(item.errors[:name]).to include("can't be blank")
    end

    # 3.descriptionが空では登録できないこと
    it "is invalid without a description" do
      item = build(:item, description: "")
      item.valid?
      expect(item.errors[:description]).to include("can't be blank")
    end

    # 4.condition_idが空では登録できないこと
    it "is invalid without a condition_id" do
      item = build(:item, condition_id: "")
      item.valid?
      expect(item.errors[:condition_id]).to include("can't be blank")
    end

    # 5.delivery_charge_idが空では登録できないこと
    it "is invalid without a delivery_charge_id" do
      item = build(:item, delivery_charge_id: "")
      item.valid?
      expect(item.errors[:delivery_charge_id]).to include("can't be blank")
    end

    # 6.delivery_charge_idが空では登録できないこと
    it "is invalid without a delivery_way_id" do
      item = build(:item, delivery_way_id: "")
      item.valid?
      expect(item.errors[:delivery_way_id]).to include("can't be blank")
    end

    # 7.shipping_period_idが空では登録できないこと
    it "is invalid without a shipping_period_id" do
      item = build(:item, shipping_period_id: "")
      item.valid?
      expect(item.errors[:shipping_period_id]).to include("can't be blank")
    end

    # 8.priceが空では登録できないこと
    it "is invalid without a price" do
      item = build(:item, price: "")
      item.valid?
      expect(item.errors[:price]).to include("can't be blank")
    end

    # 9.region_idが空では登録できないこと
    it "is invalid without a region_id" do
      item = build(:item, region_id: "")
      item.valid?
      expect(item.errors[:region_id]).to include("can't be blank")
    end

    # 10.category_idが空では登録できないこと
    it "is invalid without a category_id" do
      item = build(:item, category_id: "")
      item.valid?
      expect(item.errors[:category_id]).to include("can't be blank")
    end
   
  end
end