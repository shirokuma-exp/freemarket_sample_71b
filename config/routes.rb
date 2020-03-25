Rails.application.routes.draw do
  devise_for :users
  root 'items#index'

  resources :cards, only: [:index,:new,:show]
  resources :items, only: [:new, :create, :edit, :update, :show, :destroy]
  resources :users, only: [:edit, :update] do
    resources :addresses, only: [:new, :create]
  end
end
