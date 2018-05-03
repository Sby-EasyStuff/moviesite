Rails.application.routes.draw do
  resources :queries, only: [:show, :new, :create]
  resources :movies, except: [:new, :edit, :update, :destroy]
  resources :movies do
    resources :comments
  end
  
  resources :viewers, only: [:index, :show, :edit, :update]

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  root to: 'welcome#index'
end
