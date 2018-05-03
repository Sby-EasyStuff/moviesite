Rails.application.routes.draw do

  get '/redirect', to: 'calendars#redirect', as: 'redirect'
  get '/callback', to: 'calendars#callback', as: 'callback'

  resources :queries, only: [:show, :new, :create]
  resources :movies, except: [:new, :edit, :update, :destroy]
  resources :movies do
    post 'calendars', to: 'calendars#create', as: 'create'
    delete 'calendars', to: 'calendars#destroy', as: 'destroy'
    resources :comments
  end
  
  resources :viewers, only: [:index, :show, :edit, :update]
  resources :viewers do
    get :events
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  root to: 'welcome#index'
end
