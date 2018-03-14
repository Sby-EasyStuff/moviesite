Rails.application.routes.draw do
  resources :viewers, only: [:index, :show, :edit, :update]

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  root to: 'welcome#index'
end
