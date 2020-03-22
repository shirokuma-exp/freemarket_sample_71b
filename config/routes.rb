Rails.application.routes.draw do
  devise_for :users
  root 'items#index'
  resources :cards
  resources :items, only: [:new, :create, :edit, :update, :show, :destroy]
  resources :users, only: [:edit, :update] do
    resources :addresses, only: [:new, :create]
  end
  resources :categories, only: [:new, :show, :index]
end
