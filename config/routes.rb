require "sidekiq/web"

Rails.application.routes.draw do
  root 'dashboards#index'
  mount Sidekiq::Web => '/sidekiq'
  mount ActionCable.server => '/cable'

  namespace :admin do
    resource :sessions, only: %i[new create]
    resource :settings, only: %i[show update]
    resource :synchronizes, only: %i[create]
    resource :restore_services, only: %i[create]

    resources :registrar_users, param: :uuid
  end

  resource :sessions, only: %i[new]
  delete 'logout', to: 'sessions#destroy'

  namespace :settings do
    resources :configurations, only: %i[index create]
    resources :introduces, only: %i[index]

    namespace :est_tld do
      resource :validations, only: %i[create]
    end
  end

  namespace :auth do
    match '/tara/setup', via: %i[get post], to: 'tara#setup'
    match '/tara/callback', via: %i[get post], to: 'tara#callback', as: :tara_callback
    match '/tara/cancel', via: %i[get post delete], to: 'tara#cancel',
                          as: :tara_cancel
    get '/failure', to: 'tara#cancel'
  end

  namespace :registrar do
    resources :poll_messages, only: %i[update index] do
      scope module: :poll_messages do
        resource :dequeues, only: %i[update]
      end
    end
    resources :invoices, param: :uuid
    resources :contacts, param: :uuid do
      collection do
        get :search
      end
    end
    resources :domains, param: :uuid
    resources :renews, param: :uuid, only: %i[show update]
    resource :sessions, only: %i[new create destroy]
    resource :transfers, only: %i[show update]
    resource :settings, only: %i[show update]
  end

  namespace :registrant do
    resources :domains, param: :uuid
    resource :profiles, only: %i[edit update]
    resources :pending_actions, param: :uuid, only: %i[show]

    scope module: :invoices do
      resource :pay_invoices, only: %i[create]
      match '/pay_invoices_callback', via: %i[get], to: 'pay_invoices#callback', as: :pay_invoices_callback
    end
  end
end
