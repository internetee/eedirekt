require "sidekiq/web"

Rails.application.routes.draw do
  root 'dashboards#index'
  mount Sidekiq::Web => '/sidekiq'
  mount ActionCable.server => '/cable'

  namespace :admin do
    resource :sessions, only: %i[new create]
    resource :settings, only: %i[show update]
    resource :synchronizes, only: %i[create]
    resources :registrar_users, param: :uuid
  end

  resource :sessions, only: %i[new]
  delete 'logout', to: 'sessions#destroy'

  namespace :settings do
    resources :configurations, only: %i[index create]
    resources :introduces, only: %i[index]

    # post "configurations/validate_file" => "configurations#validate_file"
    namespace :est_tld do
      resource :validations, only: %i[create]
    end
  end

  namespace :registrar do
    resources :poll_messages, only: %i[update]
    resources :invoices, param: :uuid
    resources :contacts, param: :uuid do
      collection do
        get :search
      end
    end
    resources :domains, param: :uuid
    resource :sessions, only: %i[new create destroy]
    namespace :tara do
      get '/callback', to: 'tara#callback'
    end
  end

  namespace :registrant do
    namespace :tara do
      get '/callback', to: 'tara#callback'
    end
  end
end
