require 'swagger_helper'

describe 'Complete curriculum programmes' do
  path('/ccps') do
    get('retrieves all complete curriculum programmes') do
      tags('CCP')
      produces('application/json')

      let!(:ccps) { FactoryBot.create_list(:ccp, 2) }

      response 200, 'ccps found' do
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

    post('creates a new complete curriculum programme') do
      tags('CCP')

      consumes 'application/json'

      parameter(
        name: :ccp,
        in: :body,
        schema: {
          properties: {
            ccp: {
              type: :object,
              proprties: {
                name: { type: :string },
                benefits: { type: :string },
                overview: { type: :string }
              },
              required: %i(name benefits overview)
            },
            required: %i(ccp)
          }
        }
      )

      response(201, 'ccp created') do
        let!(:ccp) { { ccp: FactoryBot.attributes_for(:ccp) } }

        examples('application/json': { ccp: example_ccp })

        run_test! do |response|
          # all of the values in the payload should be present in the returned
          # JSON, along with some others added by saving (id, timestamps)

          JSON.parse(response.body).with_indifferent_access.tap do |json|
            ccp.dig(:ccp).each do |attribute, value|
              expect(json[attribute]).to eql(value)
            end
          end
        end
      end

      response(400, 'invalid ccp') do
        let!(:ccp) { { ccp: FactoryBot.attributes_for(:ccp, name: '') } }

        run_test! do |response|
          expect(JSON.parse(response.body).dig('errors')).to include(%(Name can't be blank))
        end
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

      response(200, 'ccp found') do
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
