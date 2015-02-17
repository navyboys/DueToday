Rails.application.routes.draw do
  root to: 'pages#front'
  get 'home', to: 'todos#index_today'

  get 'sign_up', to: "users#new"
  get 'sign_in', to: "sessions#new"
  get 'sign_out', to: "sessions#destroy"

  resources :users, only: [:create]
  resources :sessions, only: [:create]
  resources :summaries, only: [:create, :update]

  resources :todos, only: [:create, :update, :destroy]
  get 'today', to: "todos#index_today"
  get 'previous', to: "todos#index_previous_day"
  get 'history', to: "todos#history"
  post 'history', to: "todos#search"
  post 'todos/:id', to: "todos#copy_to_today"
end
