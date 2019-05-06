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
        resources :services, only: :show
      end
      resources :services, only: [:index] do
        resources :tickets, only: :index
      end
      resources :tickets, only: :show do
        resources :answers, only: :show
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
