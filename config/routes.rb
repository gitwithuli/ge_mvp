# config/routes.rb
require 'sidekiq/web'

Rails.application.routes.draw do
  # Public pages
  root 'home#index'
  get 'search', to: 'search#index'

  # Auth
  devise_for :users

  # Listings + nested favorite + promote
  resources :listings, only: %i[index show new create edit update] do
    collection { get :mine }
    member     { post :promote }
    resource :favorite, only: %i[create destroy], controller: 'favorites'
  end

  # Saved items (top-level)
  resources :favorites, only: :index

  # Conversations + messages
  resources :conversations, only: %i[index show create] do
    resources :messages, only: %i[create]
  end

  # Optional taxonomy browsing
  resources :categories, only: %i[index show]
  resources :locations,  only: %i[index show]

  # Optional dashboard
  mount Sidekiq::Web => '/sidekiq'
end
