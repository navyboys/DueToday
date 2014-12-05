Rails.application.routes.draw do
  get 'sign_up', to: "users#new"
  resources :users, only: [:create]
end
