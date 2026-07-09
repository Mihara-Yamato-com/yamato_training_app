Rails.application.routes.draw do
  root "sessions#new"

  get    "/login",  to: "sessions#new"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # 新規登録用
  resources :users, only: [:new, :create]

  # ログイン中の一般ユーザー用
  resource :user, only: [:show, :edit, :update]

  # 管理者用
  namespace :admin do
    resources :users
  end
end