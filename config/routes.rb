Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :dashboard, only: :index do
        # Глобальный поиск
        get :search, to: :search, on: :collection
      end
      resources :categories, only: %i[index show] do
        resources :services, only: :index
      end
      resources :services, only: :show
      resources :services, only: [] do
        resources :tickets, only: :index
      end
      resources :tickets, only: :show
      resources :tickets, only: [] do
        resources :answers, only: :index
      end
      resources :cases, param: :case_id
      # Получение данных о пользователе
      resources :users, only: [] do
        collection do
          get :info, to: :info
          get :owns, to: :owns
        end
      end
    end
  end
end
