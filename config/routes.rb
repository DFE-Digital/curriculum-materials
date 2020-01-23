Rails.application.routes.draw do
  get "/pages/:page", to: "pages#show"

  resource :home, only: %i(show)
  root to: 'home#show'

  resource :sessions, only: %i(create destroy)
  get '/sessions/:token', to: 'sessions#create'

  resources :complete_curriculum_programs, only: %i(show index) do
    resources :units, only: %i(show), shallow: true do
      resources :lessons, only: %i(show), shallow: true
    end
  end

  # temporary routes used for testing while setting up
  resource :protected, controller: :protected, only: %i(show)
  resource :sentry_test, controller: :sentry_test, only: %i(show)

  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all
end
