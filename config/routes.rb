Rails.application.routes.draw do
  devise_for :users
  root 'items#index'

  resources :cards, only: [:new, :show, :index, :edit] do
    collection do
      post 'pay', to: 'cards#pay'
      post 'delete', to: 'cards#delete'
      post 'buy', to: 'cards#buy'
    end
  end
  resources :items, only: [:new, :create, :edit, :update, :show, :destroy]
  resources :users, only: [:edit, :update] do
    resources :addresses, only: [:new, :create]
  end
end
