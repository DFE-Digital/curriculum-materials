require 'swagger_helper'

describe 'Lessons' do
  path('/ccps/{ccp_id}/units/{unit_id}/lessons') do
    get('retrieves all lessons belonging to the specified CCP and unit') do
      tags('Lesson')
      produces('application/json')

      let(:lesson) { FactoryBot.create(:lesson) }

      let(:ccp_id) { lesson.unit.complete_curriculum_programme.id }
      let(:unit_id) { lesson.unit.id }

      parameter(name: :ccp_id, in: :path, type: :string, required: true)
      parameter(name: :unit_id, in: :path, type: :string, required: true)

      response '200', 'lessons found' do
        examples('application/json': example_lessons(2))

        schema(type: :array, items: { '$ref' => '#/components/schemas/lesson' })

        run_test!
      end
    end

    post('creates a lesson belonging to the specified unit') do
      tags('Lesson')

      let(:lesson) { FactoryBot.create(:lesson) }
      let(:ccp_id) { lesson.unit.complete_curriculum_programme.id }
      let(:unit_id) { lesson.unit.id }

      consumes 'application/json'

      parameter(name: :ccp_id, in: :path, type: :string, required: true)
      parameter(name: :unit_id, in: :path, type: :string, required: true)
      parameter(
        name: :lesson_params,
        in: :body,
        schema: {
          properties: { 
            lesson: {
              '$ref' => '#/components/schemas/lesson', required: %i(lesson)
            }
          }
        }
      )

      request_body_json(
        schema: {
          properties: { '$ref' => '#/components/schemas/lesson', required: %i(lesson) }
        }
      )

      response(201, 'lesson created') do
        let!(:lesson_params) { { lesson: FactoryBot.attributes_for(:lesson) } }

        examples('application/json': { lesson: FactoryBot.attributes_for(:lesson) })

        run_test! do |response|
          JSON.parse(response.body).with_indifferent_access.tap do |json|
            lesson_params.dig(:lesson).each do |attribute, value|
              expect(json[attribute]).to eql(value)
            end
          end
        end
      end

      response(400, 'invalid unit') do
        let!(:lesson_params) { { lesson: FactoryBot.attributes_for(:lesson, name: '') } }

        run_test! do |response|
          expect(JSON.parse(response.body).dig('errors')).to include(%(Name can't be blank))
        end
      end
    end
  end

  path('/ccps/{ccp_id}/units/{unit_id}/lessons/{id}') do
    get('retrieves a single lesson belonging to the specified CCP and unit') do
      tags('Lesson')
      produces('application/json')

      let(:lesson) { FactoryBot.create(:lesson) }

      let(:ccp_id) { lesson.unit.complete_curriculum_programme.id }
      let(:unit_id) { lesson.unit.id }
      let(:id) { lesson.id }

      parameter(name: :ccp_id, in: :path, type: :string, required: true)
      parameter(name: :unit_id, in: :path, type: :string, required: true)
      parameter(name: :id, in: :path, type: :string, required: true)

      request_body_json(
        schema: {
          properties: { '$ref' => '#/components/schemas/lesson', required: %i(lesson) }
        }
      )

      response('200', 'lesson found') do
        examples('application/json': example_lesson)

        schema('$ref' => '#/components/schemas/lesson')

        run_test!
      end
    end

    patch('update the referenced lesson') do
      tags('Lesson')

      consumes 'application/json'

      let(:lesson) { FactoryBot.create(:lesson) }
      let(:unit) { lesson.unit }
      let(:ccp) { unit.complete_curriculum_programme }
      let(:unit_id) { unit.id }
      let(:ccp_id) { ccp.id }
      let(:id) { lesson.id }
      let(:lesson_params) { { lesson: FactoryBot.attributes_for(:lesson) } }

      parameter(name: :ccp_id, in: :path, type: :string, required: true)
      parameter(name: :unit_id, in: :path, type: :string, required: true)
      parameter(name: :id, in: :path, type: :string, required: true)
      parameter(
        name: :lesson_params,
        in: :body,
        schema: {
          properties: { 
            lesson: {
              '$ref' => '#/components/schemas/lesson', required: %i(lesson)
            }
          }
        }
      )

      request_body_json(schema: { '$ref' => '#/components/schemas/lesson' })

      response(200, 'lesson updated') do
        examples('application/json': { lesson: FactoryBot.attributes_for(:lesson) })

        run_test! do |response|
          JSON.parse(response.body).with_indifferent_access.tap do |json|
            lesson_params.dig(:lesson).each do |attribute, value|
              expect(json[attribute]).to eql(value)
            end
          end
        end
      end

      response(400, 'invalid lesson') do
        let(:lesson_params) { { lesson: FactoryBot.attributes_for(:lesson, name: '') } }

        run_test! do |response|
          expect(JSON.parse(response.body).dig('errors')).to include(%(Name can't be blank))
        end
      end
    end
  end
end
