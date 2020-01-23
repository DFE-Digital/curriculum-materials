Rails.application.routes.draw do
  get "/pages/:page", to: "pages#show"

  resource :home, only: %i(show)
  root to: 'homes#show'

  resource :splash, only: %i(show)

  resource :sessions, only: %i(create destroy)
  get '/sessions/:token', to: 'sessions#create'

  # temporary routes used for testing while setting up
  resource :protected, controller: :protected, only: %i(show)
  resource :sentry_test, controller: :sentry_test, only: %i(show)

  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all
end
