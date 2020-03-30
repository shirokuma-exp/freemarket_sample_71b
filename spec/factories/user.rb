FactoryBot.define do

  factory :user do
    nickname              {"hoge"}
    email                 {Faker::Internet.email}
    name                  {"hoge"}
    name_kana             {"hoge"}
    birthday              {"20200202"}
    phone_number          {"09012345678"}
    sex                   {"men"}
    password              {"00000000"}
    password_confirmation {"00000000"}

  end

end