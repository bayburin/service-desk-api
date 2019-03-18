Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :dashboard, only: :index do
        # Глобальный поиск
        get :search, to: 'dashboard#search', params: :search, on: :collection
      end
      resources :categories, only: %i[index show] do
        resources :services, only: :index
      end
      resources :services, only: :show do
        resources :tickets, only: %i[index show]
      end
      resources :cases, params: :case_id
      # Получение данных о пользователе
      get 'users/info', to: 'users#info'
    end
  end
end
