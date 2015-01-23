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
  get 'todos/today', to: "todos#index_today"
  get 'todos/previous_day', to: "todos#index_previous_day"
  get 'todos/history', to: "todos#history"
  post 'todos/history', to: "todos#search"
  post 'todos/:id', to: "todos#copy_to_today"
end
