crumb :root do
  link "トップページ", root_path
end

crumb :mypage do
  link "マイページ", edit_user_path(current_user)
end

crumb :user_new do
  link "新規ユーザー登録", new_user_session_path
end

crumb :user_session do
  link "ログイン", user_session_path
end

crumb :user_address do
  link "住所登録", new_user_address_path
  parent :user_session
end

crumb :card do
  link "カード登録", new_user_card_path(current_user)
  parent :mypage
end

crumb :card_show do
  link "カード情報", user_card_path(current_user)
  parent :mypage
end

crumb :buy_item do
  link "商品一覧", root_path
  parent :root
end

crumb :items do |item|
  item = Item.all.find(params[:id])
  link item.name, item_path,@item
  parent :buy_item
end