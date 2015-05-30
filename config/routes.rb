Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  resources :users, only: [:show, :destroy]

  get 'admin/users', to: 'admins#all_users', as: 'all_users'

  resources :schedules, only: [:new, :create, :show]

  root 'schedules#new'
end
