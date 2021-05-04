Rails.application.routes.draw do
  
  devise_for :users, controllers: {
    passwords:          'users/passwords',
    registrations:      'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions:           'users/sessions',
    confirmations:      "users/confirmations"
  }

  # devise_for :admins, controllers: {
  #   sessions:      'admins/sessions',
  #   passwords:     'admins/passwords'
  # }

  authenticated :user do
    scope module: :user do
      resources :social_profiles, only: :destroy
      resource :user_profile, only: [:edit, :update, :show]
      resources :notifications, only: [:index]
      resources :teams
      resources :requests
      resource :ratings
      resource :rooms, path: :chat, only: [:show]
      resource :violation_reports, only: [:new, :create]
    end
  end

  namespace :api, format: 'json' do
    namespace :v1 do
      resource  :stripe_checkout_session, only: [:create]
      resource  :stripe_webhook, only: [:create]
    end
  end

  root 'static_pages#home'
end
