Rails.application.routes.draw do

  # Tips: type 'rails routes' in the console

  # Sets home as root
  root 'static_pages#home'
  # Connects links to path
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/users', to: 'users#index'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  # Connects links to path after post
  post '/signup', to: 'users#create'
  post '/login', to: 'sessions#create'
  # Connects links to path after delete
  delete '/logout', to: 'sessions#destroy'

  # Access the routing for users
  # resources :users
  # Access the routing for account activation
  resources :account_activations, only: [:edit]
  # Access the routing for password reset
  resources :password_resets, only:[:new, :create, :edit, :update]
  # Access the routing for microposts
  resources :microposts, only: [:create, :destroy]
  #
  resources :users do
    member do
      get :following, :followers
    end
  end
  #
  resources :relationships, only: [:create, :destroy]

end
