Rails.application.routes.draw do
  require 'sidekiq/web'
  Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

  devise_for :users

  root to: 'application#welcome'

  mount ActionCable.server => '/cable'
  # mount Sidekiq::Web => '/sidekiq'

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      get 'welcome', to: 'base#welcome'
      post 'auth/token'
      post 'auth/revoke'

      resources :dashboard, only: :index do
        # Глобальный поиск
        get :search, to: :search, on: :collection
        get :deep_search, to: :deep_search, on: :collection
      end
      resources :categories, only: %i[index show] do
        resources :services, only: :show
      end
      resources :services, only: [] do
        resources :question_tickets do
          post :raise_rating, to: :raise_rating, on: :member
        end
      end
      resources :responsible_users, only: :index do
        get :search, to: :search, on: :collection
      end
      resources :cases, only: %i[index create update destroy], param: :case_id
      # Получение данных о пользователе
      resources :users, only: [] do
        collection do
          get :info, to: :info
          get :owns, to: :owns
          get :notifications, to: :notifications
          get :new_notifications, to: :new_notifications
        end
      end
      resources :tags, only: :index do
        get :popular, to: :popular, on: :collection
      end
      resources :answers, only: [] do
        resources :answer_attachments, only: %i[show create destroy]
      end

      post 'question_tickets/publish', to: 'question_tickets#publish'
    end

    namespace :v2 do
      get 'welcome', to: 'base#welcome'

      resources :answers, only: [] do
        resources :answer_attachments, only: :show
      end
    end
  end
end
