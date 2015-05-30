Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  resources :users, only: [:show, :destroy]

  get 'admin/users', to: 'admins#all_users', as: 'all_users'
  post 'schedules', to: 'schedules#find_or_create',
                    as: 'find_or_create_schedule'

  resources :schedules, only: [:new, :show]

  root 'schedules#new'
end
