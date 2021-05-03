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
    end
  end

  root 'static_pages#home'
end
