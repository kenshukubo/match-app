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
      resource  :user_profile, only: [:edit, :update]
      resources :posts, only: [:new, :show, :create, :edit, :update, :destroy]
      resources :post_members, only: [:new, :create, :edit, :update, :destroy]
      resources :attack_groups, only: [:index, :new, :destroy]
      resources :attackers, only: [:create, :edit, :update, :destroy]
      resources :social_profiles, only: :destroy
      resources :requests, only: [:index, :edit, :update]
      resource  :ratings
      resource  :rooms, path: :chat, only: [:show]
      resource  :violation_reports, only: [:new, :create]
    end
  end

  namespace :api, format: 'json' do
    namespace :v1 do
      #stripe
      resource  :stripe_checkout_session, only: [:create]
      resource  :stripe_webhook, only: [:create]

      #通知
      resources :usuall_notifications, only: [:index]
      resources :admin_notifications, only: [:index]
      resource  :notification_count, only: [:show]

      #フレンド検索、追加、削除
      resources :searches, only: [:index]
      resources :search_friends, only: [:index]
      resource  :friends, only: [:create, :destroy]

      #トップページ
      resources :posts, only: [:index, :destroy]
      resource  :zoom_in_profile, only: [:show]
      resource  :post_listed_check, only: [:update]
      resource  :attack_group_check, only: [:show]
      resources :requests, only: [:index, :create]

      #メンバー追加(PostMember, Attacker)
      resources :check_friends, only: [:index]
      resources :search_users, only: [:index]
      resources :add_post_members, only: [:create]
      resources :attack_groups, only: [:create]
      resources :add_attackers, only: [:index, :create]

      #チャット
      resources :rooms, only: [:show, :index], param: :identified_char do
        resources :room_messages, only: [:show, :index]
      end
      resource  :current_user, only: [:show]
    end
  end

  root  'static_pages#home'
  patch 'static_pages' => "static_pages#update"
end
