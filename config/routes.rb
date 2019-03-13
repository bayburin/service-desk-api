Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end

  get 'users/info', to: 'users#info'

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :categories
      resources :cases, params: :case_id
      # Глобальный поиск
      get :search, to: 'base#search'
    end
  end
end
