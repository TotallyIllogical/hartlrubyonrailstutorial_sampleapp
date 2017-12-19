Rails.application.routes.draw do

  # Access the routing for users
  resources :users
  # Access the routing for account activation
  resources :account_activation, only: [:edit]

  # get 'sessions/new'
  # get 'users/new'

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

end
