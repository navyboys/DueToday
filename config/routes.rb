Rails.application.routes.draw do
  root to: 'pages#front'
  get 'home', to: 'todos#today'
  
  get 'sign_up', to: "users#new"
  get 'sign_in', to: "sessions#new"
  get 'sign_out', to: "sessions#destroy"

  resources :users, only: [:create]
  resources :sessions, only: [:create]
end
