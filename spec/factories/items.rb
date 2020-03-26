FactoryBot.define do

  factory :item do
    name                {"hoge"}
    description         {"hoge"}
    condition_id        {"1"}
    size                {"L"}
    delivery_charge_id  {"1"}
    delivery_way_id     {"1"}
    shipping_period_id  {"1"}
    region_id           {"1"}
    price               {"1000"}
    like                {"hoge"}
    user_id             {"1"}
    buyer_id            {"1"}
    status              {"1"}
    category_id         {"1"}
    brand_name          {"hoge"}
  end

end