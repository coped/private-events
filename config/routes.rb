Rails.application.routes.draw do
  get 'invitations/index'
  get 'invitations/new'
  get 'invitations/show'
  get 'invitations/edit'
  root   'static_pages#home'
  get    'login',  to: 'sessions#new'
  post   'login',  to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :users, only: [:new, :create, :show]
  resources :events, only: [:new, :create, :show, :index]
  resources :invitations, only: [:create, :show, :update, :destroy]
end
