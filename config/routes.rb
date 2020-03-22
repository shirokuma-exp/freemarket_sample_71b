Rails.application.routes.draw do
  devise_for :users
  root 'items#index'
  resources :items, only: [:new, :create, :edit, :update, :show, :destroy]
  resources :users, only: [:edit, :update] do
    resources :addresses, only: [:new, :create]
  end
  resources :cards,only:[:index,:new,:show]do
    collection do
      #payjpでトークン化を行う
      post 'pay', to: 'cards#pay'
      #カード削除
      post 'delete', to: 'cards#delete'
      #カード情報入力
      post 'show', to: 'cards#show'
    end
  end
end
