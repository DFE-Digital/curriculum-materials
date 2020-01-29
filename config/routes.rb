Rails.application.routes.draw do
  # Frontend
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

  resources :units, only: %i(show)

  # API
  if Rails.env.development?
    mount OpenApi::Rswag::Ui::Engine => '/api-docs'
    mount OpenApi::Rswag::Api::Engine => '/api-docs'
  end

  namespace :api do
    namespace :v1 do
      resources :ccps, controller: 'complete_curriculum_programmes', only: %i(index show) do
        resources :units, only: %i(index show) do
          resources :lessons, only: %i(index show) do
            resources :lesson_parts, only: %i(index show)
          end
        end
      end
    end
  end
end
