require 'swagger_helper'

describe 'Complete curriculum programmes' do
  include_context 'setup api token'

  let(:maths) { 'Maths' }
  let!(:maths_subject) { FactoryBot.create(:subject, name: maths) }

  path('/ccps') do
    get('retrieves all complete curriculum programmes') do
      tags('CCP')
      produces('application/json')

      parameter(name: 'Authorization', in: :header, type: :string)

      let!(:ccps) { FactoryBot.create_list(:ccp, 2) }

      response 200, 'ccps found' do
        examples(
          'application/json': example_ccp
        )

        schema(type: :array, items: { '$ref' => '#/components/schemas/ccp' })

        run_test!
      end

      response(401, 'unauthorized') do
        it_should_behave_like 'an endpoint that requires token auth'
      end
    end

    post('creates a new complete curriculum programme') do
      tags('CCP')

      consumes 'application/json'

      parameter(name: 'Authorization', in: :header, type: :string)
      parameter(
        name: :ccp_params,
        in: :body,
        schema: {
          properties: {
            ccp: { '$ref' => '#/components/schemas/ccp' },
            subject: { type: :string }
          }
        }
      )

      request_body_json(schema: { '$ref' => '#/components/schemas/ccp' })

      response(201, 'ccp created') do
        let!(:ccp_params) { { ccp: FactoryBot.attributes_for(:ccp), subject: maths } }

        examples('application/json': { ccp: FactoryBot.attributes_for(:ccp), subject: 'English' })

        run_test! do |response|
          # all of the values in the payload should be present in the returned
          # JSON, along with some others added by saving (id, timestamps)

          JSON.parse(response.body).with_indifferent_access.tap do |json|
            ccp_params.dig(:ccp).each do |attribute, value|
              expect(json[attribute]).to eql(value)
            end

            expect(json['subject']).to eql('Maths')
          end
        end
      end

      response(400, 'invalid ccp') do
        let!(:ccp_params) { { ccp: FactoryBot.attributes_for(:ccp, name: '') } }

        run_test! do |response|
          expect(JSON.parse(response.body).dig('errors')).to include(%(Name can't be blank))
        end
      end

      response(400, 'non-existant subject') do
        let!(:ccp_params) { { ccp: FactoryBot.attributes_for(:ccp, name: ''), subject: 'Defense Against the Dark Arts' } }

        run_test! do |response|
          expect(JSON.parse(response.body).dig('errors')).to include(%(Subject must exist))
        end
      end

      response(401, 'unauthorized') do
        it_should_behave_like 'an endpoint that requires token auth'
      end
    end
  end

  path('/ccps/{id}') do
    get('retrieves one complete curriculum programme') do
      tags('CCP')
      produces('application/json')

      parameter(name: 'Authorization', in: :header, type: :string)
      parameter(name: :id, in: :path, type: :string, required: true)

      let!(:ccp) { FactoryBot.create(:ccp) }
      let(:id) { ccp.id }

      response(200, 'ccp found') do
        examples('application/json': example_ccp.merge(units: example_units(2)))

        schema('$ref' => '#/components/schemas/ccp')

        run_test!
      end

      response(401, 'unauthorized') do
        it_should_behave_like 'an endpoint that requires token auth'
      end
    end

    patch('update the referenced complete curriculum programme') do
      tags('CCP')

      consumes 'application/json'
      let(:ccp) { FactoryBot.create(:ccp) }
      let(:id) { ccp.id }
      let(:ccp_params) { { ccp: FactoryBot.attributes_for(:ccp), subject: maths } }

      parameter(name: 'Authorization', in: :header, type: :string)
      parameter(name: :id, in: :path, type: :string, required: true)
      parameter(
        name: :ccp_params,
        in: :body,
        schema: {
          properties: {
            ccp: { '$ref' => '#/components/schemas/ccp' },
            subject: { type: :string }
          }
        }
      )

      request_body_json(schema: { '$ref' => '#/components/schemas/ccp' })

      response(200, 'ccp updated') do
        examples('application/json': { ccp: FactoryBot.attributes_for(:ccp), subject: 'French' })

        run_test! do |response|
          JSON.parse(response.body).with_indifferent_access.tap do |json|
            ccp_params.dig(:ccp).each do |attribute, value|
              expect(json[attribute]).to eql(value)
            end

            expect(json['subject']).to eql('Maths')
          end
        end
      end

      response(400, 'invalid ccp') do
        let!(:ccp_params) { { ccp: FactoryBot.attributes_for(:ccp, name: '') } }

        run_test! do |response|
          expect(JSON.parse(response.body).dig('errors')).to include(%(Name can't be blank))
        end
      end

      response(400, 'non-existant subject') do
        let!(:ccp_params) { { ccp: FactoryBot.attributes_for(:ccp, name: ''), subject: 'Defense Against the Dark Arts' } }

        run_test! do |response|
          expect(JSON.parse(response.body).dig('errors')).to include(%(Subject must exist))
        end
      end

      response(401, 'unauthorized') do
        it_should_behave_like 'an endpoint that requires token auth'
      end
    end
  end
end
