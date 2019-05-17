Rails.application.routes.draw do
  devise_for :users

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :dashboard, only: :index do
        # Глобальный поиск
        get :search, to: :search, on: :collection
      end
      resources :categories, only: %i[index show] do
        resources :services, only: :show
      end
      resources :services, only: :index do
        resources :tickets, only: :show
      end
      # resources :tickets, only: :show do
      #   resources :answers, only: :show
      # end
      resources :cases, param: :case_id
      # Получение данных о пользователе
      resources :users, only: [] do
        collection do
          get :info, to: :info
          get :owns, to: :owns
        end
      end

      post 'auth/token'
      post 'auth/revoke'
    end
  end
end
