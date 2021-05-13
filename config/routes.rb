Rails.application.routes.draw do
  
  devise_for :users, controllers: {
    passwords:          'users/passwords',
    registrations:      'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions:           'users/sessions',
    confirmations:      "users/confirmations",
    invitations:        "users/invitations"
  }

  # devise_for :admins, controllers: {
  #   sessions:      'admins/sessions',
  #   passwords:     'admins/passwords'
  # }

  authenticated :user do
    scope module: :user do
      resources :social_profiles, only: :destroy
      resource :user_profile, only: [:edit, :update, :show]
      resources :posts
      resources :post_members
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
      resources :usuall_notifications, only: [:index]
      resources :admin_notifications, only: [:index]
      resource :notification_count, only: [:show]
      resource :search, only: [:show]
      resource :friend, only: [:create]
    end
  end

  root 'static_pages#home'
end
