require 'swagger_helper'
=begin
xdescribe 'Units' do
  before { skip("TODO Fix data shape") }
  path('/ccps/{ccp_id}/units') do
    get('retrieves all units belonging to the provided CCP') do
      tags('Unit')
      produces('application/json')

      let!(:ccp) { FactoryBot.create(:ccp) }
      let(:ccp_id) { ccp.id }
      let!(:units) { FactoryBot.create_list(:unit, 2, complete_curriculum_programme_id: ccp_id) }

      parameter(name: :ccp_id, in: :path, type: :string, required: true)

      response '200', 'units found' do
        examples('application/json': example_units(2))

        schema(type: :array, items: { '$ref' => '#/components/schemas/unit' })

        run_test!
      end
    end

    post('creates a new unit belonging to the specified CCP') do
      tags('Unit')

      let(:ccp) { FactoryBot.create(:ccp) }
      let(:ccp_id) { ccp.id }

      consumes 'application/json'

      parameter(name: :ccp_id, in: :path, type: :string, required: true)
      parameter(
        name: :unit_params,
        in: :body,
        schema: {
          properties: {
            unit: {
              '$ref' => '#/components/schemas/unit', required: %i(unit)
            }
          }
        }
      )

      request_body_json(
        schema: {
          properties: { '$ref' => '#/components/schemas/unit', required: %i(unit) }
        }
      )

      response(201, 'unit created') do
        let!(:unit_params) { { unit: FactoryBot.attributes_for(:unit) } }

        examples('application/json': { unit: example_unit })

        run_test! do |response|
          # all of the values in the payload should be present in the returned
          # JSON, along with some others added by saving (id, timestamps)

          JSON.parse(response.body).with_indifferent_access.tap do |json|
            unit_params.dig(:unit).each do |attribute, value|
              expect(json[attribute]).to eql(value)
            end
          end
        end
      end

      response(400, 'invalid unit') do
        let!(:unit_params) { { unit: FactoryBot.attributes_for(:unit, name: '') } }

        run_test! do |response|
          expect(JSON.parse(response.body).dig('errors')).to include(%(Name can't be blank))
        end
      end
    end
  end

  path('/ccps/{ccp_id}/units/{id}') do
    get('retrieves a single unit belonging to the specified CCP') do
      tags('Unit')
      produces('application/json')

      let!(:unit) { FactoryBot.create(:unit) }
      let!(:ccp_id) { unit.complete_curriculum_programme_id }
      let!(:id) { unit.id }
      let!(:lessons) { FactoryBot.create_list(:lesson, 3, unit_id: id) }

      parameter(name: :ccp_id, in: :path, type: :string, required: true)
      parameter(name: :id, in: :path, type: :string, required: true)

      response('200', 'unit found') do
        examples(
          'application/json': example_unit.merge(
            complete_curriculum_programme: 94
            ,
            lessons: example_lessons(3)
          )
        )

        schema('$ref' => '#/components/schemas/unit')

        run_test!
      end
    end

    patch('update the referenced unit') do
      tags('Unit')

      consumes 'application/json'

      let(:ccp) { FactoryBot.create(:ccp) }
      let(:unit) { FactoryBot.create(:unit, complete_curriculum_programme: ccp) }
      let(:ccp_id) { ccp.id }
      let(:id) { unit.id }
      let(:unit_params) { { unit: FactoryBot.attributes_for(:unit) } }

      parameter(name: :ccp_id, in: :path, type: :string, required: true)
      parameter(name: :id, in: :path, type: :string, required: true)
      parameter(
        name: :unit_params,
        in: :body,
        schema: {
          properties: {
            unit: {
              '$ref' => '#/components/schemas/unit', required: %i(unit)
            }
          }
        }
      )

      request_body_json(schema: { '$ref' => '#/components/schemas/unit' })

      response(200, 'unit updated') do
        examples('application/json': { unit: FactoryBot.attributes_for(:unit) })

        run_test! do |response|
          JSON.parse(response.body).with_indifferent_access.tap do |json|
            unit_params.dig(:unit).except(:slug).each do |attribute, value|
              expect(json[attribute]).to eql(value)
            end
          end
        end
      end

      response(400, 'invalid unit') do
        let(:unit_params) { { unit: FactoryBot.attributes_for(:unit, name: '') } }

        run_test! do |response|
          expect(JSON.parse(response.body).dig('errors')).to include(%(Name can't be blank))
        end
      end
    end
  end
end
=end
