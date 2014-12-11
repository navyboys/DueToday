Rails.application.routes.draw do
  root to: 'pages#front'
  get 'home', to: 'todos#index_today'

  get 'sign_up', to: "users#new"
  get 'sign_in', to: "sessions#new"
  get 'sign_out', to: "sessions#destroy"

  resources :users, only: [:create]
  resources :sessions, only: [:create]

  resources :todos, only: [:create, :destroy]
  get 'todos/today', to: "todos#index_today"
end
