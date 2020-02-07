Rails.application.routes.draw do
  # Frontend
  get "/pages/:page", to: "pages#show"

  # temporary routes used for testing while setting up
  resource :sentry_test, controller: :sentry_test, only: %i(show)

  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all

  namespace :teachers do
    resource :home, only: %i(show)
    resource :splash, only: %i(show)

    resource :session, only: %i(destroy) do
      get '/:token', to: 'sessions#create', as: 'create'
    end

    resources :complete_curriculum_programmes, only: %i(index show)

    resources :units, only: %i(show)
    resources :lessons, only: %i(show)

    resource :logged_out, only: %i(show), controller: 'logged_out'
  end

  root to: 'teachers/homes#show'

  # API
  API_VERSIONS = [1].freeze

  if Rails.env.development?
    mount OpenApi::Rswag::Ui::Engine => '/api-docs'
    mount OpenApi::Rswag::Api::Engine => '/api-docs'
  end

  namespace :api do
    namespace :v1 do
      resources :ccps, controller: 'complete_curriculum_programmes', only: %i(index show create update) do
        resources :units, only: %i(index show create update) do
          resources :lessons, only: %i(index show create update) do
            resources :lesson_parts, only: %i(index show)
          end
        end
      end
    end
  end

  api_router = Proc.new do |env|
    original_endpoint = env.dig("action_dispatch.request.path_parameters", :original_endpoint)

    version = env.fetch("HTTP_APIVERSION") { API_VERSIONS.last }

    fail("Invalid API version, must be in #{API_VERSIONS}") unless version.to_i.in?(API_VERSIONS)

    new_endpoint = "/" + ["api", "v#{version}", original_endpoint].join('/')

    [302, { "Location" => new_endpoint }, []]
  end

  match "/api/*original_endpoint", via: %i(get post), to: api_router
end
