Rails.application.routes.draw do
  devise_for :users
  root 'items#index'

  resources :items, only: [:new, :create, :edit, :update, :show, :destroy] do
    collection do
      get 'get_category_children', defaults: { format: 'json' }
      get 'get_category_grandchildren', defaults: { format: 'json' }
    end
    member do 
      get 'get_category_children', defaults: { format: 'json' }
      get 'get_category_grandchildren', defaults: { format: 'json' }
    end
    member do
      get 'purchase', to:'items#purchase'
      post 'pay', to:'items#pay'
      get 'done', to:'items#done'
    end
    collection do
      get 'search', to: 'items#search'
    end
  end

  resources :users, only: [:edit, :update] do
    resources :addresses, only: [:new, :create]
    resources :cards, only: [:new, :show, :destroy] do
      collection do
        post 'show', to: 'cards#show'
        post 'pay', to: 'cards#pay'
        post 'delete', to: 'cards#delete'
      end
    end
  end
  resources :categories, only: [:new, :show, :index]
end