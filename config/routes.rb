Rails.application.routes.draw do
  root to: 'pages#front'
  get 'home', to: 'todos#index_today'

  get 'sign_up', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'

  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  get 'expired_token', to: 'password_resets#expired_token'
  resources :forgot_passwords, only: [:create]
  resources :password_resets, only: [:show, :create]

  resources :users, only: [:create, :update]
  get 'profile', to: 'users#edit'

  resources :sessions, only: [:create]
  resources :summaries, only: [:create, :update]

  resources :charges, only: [:new, :create]

  resources :todos, only: [:create, :update, :destroy]
  get 'today', to: 'todos#index_today'
  get 'previous', to: 'todos#index_previous_day'
  get 'history', to: 'todos#history'
  post 'history', to: 'todos#search'
  post 'todos/:id', to: 'todos#copy_to_today'
end
