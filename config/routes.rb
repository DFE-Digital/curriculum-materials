Rails.application.routes.draw do
  # Frontend
  get "/pages/:page", to: "pages#show"

  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all

  namespace :teachers do
    resource :home, only: %i(show)
    resource :splash, only: %i(show)

    resource :session, only: %i(destroy) do
      get '/:token', to: 'sessions#create', as: 'create'
    end

    resources :complete_curriculum_programmes, only: %i(index show), path: 'complete-curriculum-programmes' do
      resources :years, only: %i(show)
    end

    resources :units, only: %i(show)

    resources :lessons, only: %i(show) do
      member do
        get :print
      end
      resources :downloads, only: %i(show create), shallow: true
    end

    resources :lesson_parts, only: %i(show) do
      resource :activity_choice, only: %i(new create edit update), as: :choice
    end

    resource :logged_out, only: %i(show), controller: 'logged_out'
  end

  namespace :suppliers do
    resources :complete_curriculum_programmes, path: 'ccps' do
      resources :units do
        resources :lessons do
          resources :lesson_parts do
            resources :activities
          end
        end
      end
    end
  end

  root to: 'teachers/homes#show'

  # API
  if Rails.env.development?
    mount OpenApi::Rswag::Ui::Engine => '/api-docs'
    mount OpenApi::Rswag::Api::Engine => '/api-docs'
  end

  namespace :api do
    namespace :v1 do
      resources :ccps, controller: 'complete_curriculum_programmes', only: %i(index show create update) do
        resources :units, only: %i(index show create update) do
          resources :lessons, only: %i(index show create update) do
            resources :lesson_parts, only: %i(index show create update) do
              resources :activities, only: %i(index show create update) do
                resources :pupil_resources, only: %i(index create destroy)
                resources :teacher_resources, only: %i(index create destroy)
                resource :slide_deck, only: %i(show create destroy)
              end
            end
          end
        end
      end

      resources :teaching_methods, only: %i(index show)
      resources :subjects, only: %i(index show)
    end
  end
end
