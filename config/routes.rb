Rails.application.routes.draw do
  devise_for :users

  root to: 'application#welcome'

  mount ActionCable.server => '/cable'
  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :dashboard, only: :index do
        # Глобальный поиск
        get :search, to: :search, on: :collection
        get :deep_search, to: :deep_search, on: :collection
      end
      resources :categories, only: %i[index show] do
        resources :services, only: :show
      end
      resources :services, only: :index do
        resources :tickets do
          post :raise_rating, to: :raise_rating, on: :member
        end
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
        get :popularity, to: :popularity, on: :collection
      end
      resources :answers, only: [] do
        resources :answer_attachments, only: %i[show create destroy]
      end

      get 'welcome', to: 'base#welcome'
      post 'auth/token'
      post 'auth/revoke'
      post 'tickets/publish', to: 'tickets#publish'
    end
  end
end
