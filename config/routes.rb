Rails.application.routes.draw do
  get "sessions/new"
  get "users/show"
  get "users/edit"
  get "users/new"

  root "sessions#new"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resource :user, only: [:show, :edit, :update]

  namespace :admin do
    get "users/index"
    get "users/show"
    get "users/edit"
    resources :users
  end
end
