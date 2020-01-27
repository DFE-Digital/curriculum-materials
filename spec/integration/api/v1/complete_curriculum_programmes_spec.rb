require 'swagger_helper'

describe 'Complete curriculum programmes' do
  path('/ccps') do
    get('retrieves all complete curriculum programmes (CCPs)') do
      tags('CCP')
      produces('application/json')

      let!(:ccps) { FactoryBot.create_list(:ccp, 2) }

      response '200', 'ccps found' do
        examples(
          'application/json': [example_ccp]
        )

        schema(
          type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              benefits: { type: :string },
              overview: { type: :string },
            }
          }
        )

        run_test!
      end
    end
  end

  path('/ccps/{id}') do
    get('retrieves one complete curriculum programme (CCP)') do
      tags('CCP')
      produces('application/json')

      parameter(name: :id, in: :path, type: :string, required: true)

      let!(:ccp) { FactoryBot.create(:ccp) }
      let(:id) { ccp.id }

      response('200', 'ccp found') do
        examples('application/json': example_ccp.merge(units: example_units(2)))

        schema(
          type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            benefits: { type: :string },
            overview: { type: :string },

            # retrieving a single CCP also returns its units
            units: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  benefits: { type: :string },
                  overview: { type: :string }
                }
              }
            }
          }
        )

        run_test!
      end
    end
  end
end
