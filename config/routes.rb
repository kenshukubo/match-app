Rails.application.routes.draw do
  
  devise_for :users, controllers: {
    passwords:          'users/passwords',
    registrations:      'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions:           'users/sessions',
    confirmations:      "users/confirmations"
  }

  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords'
  }

  root 'static_pages#home'
end
