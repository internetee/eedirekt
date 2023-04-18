Rails.application.routes.draw do
  root 'dashboards#index'

  namespace :admin do
    resource :sessions, only: %i[new create]
  end

  resource :sessions, only: %i[new]
  delete 'logout', to: 'sessions#destroy'

  resources :registrar_users, param: :uuid

  namespace :settings do
    resources :configurations, only: %i[index create]
    resources :introduces, only: %i[index]

    # post "configurations/validate_file" => "configurations#validate_file"
    namespace :est_tld do
      resource :validations, only: %i[create]
    end
  end

  namespace :registrar do
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
