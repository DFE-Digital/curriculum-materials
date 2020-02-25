require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.configuration.x.swagger_root

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.json' => {
      openapi: '3.0.0',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      components: {
        schemas: {
          ccp: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              benefits: { type: :string },
              overview: { type: :string },
            },
            required: %i(name benefits overview)
          },
          unit: {
            type: :object,
            properties: {
              name: { type: :string },
              benefits: { type: :string },
              overview: { type: :string }
            },
            required: %i(name benefits overview)
          },
          lesson: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              summary: { type: :string },
              core_knowledge: { type: :string },
              previous_knowledge: { type: :object },
              vocabulary: {
                type: :array, items: { type: :string }
              },
              misconceptions: {
                type: :array, items: { type: :string }
              },
            },
            required: %i(name summary core_knowledge previous_knowledge vocabulary misconceptions)
          },
          lesson_part: {
            type: :object,
            properties: {
              id: { type: :integer },
              position: { type: :integer }
            }
          },
          activity: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              overview: { type: :string },
              duration: { type: :integer },
              extra_requirements: {
                type: :array, items: { type: :string }
              }
            }
          },
          teaching_methods: {
            type: :array, items: { type: :string }
          },

          # metadata
          teaching_method: {
            type: :object,
            properties: {
              name: { type: :string },
              icon: { type: :string }
            }
          }
        }
      },
      basePath: '/api/v1',
      paths: {},
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000/api/v1'
            }
          }
        }
      ]
    }
  }
end
