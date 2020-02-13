require 'swagger_helper'

describe 'Lessons parts' do
  path('/ccps/{ccp_id}/units/{unit_id}/lessons/{lesson_id}/lesson_parts') do
    get('retrieves all lessons parts belonging to the specified lesson') do
      tags('LessonPart')
      produces('application/json')

      let(:lesson_part) { FactoryBot.create(:lesson_part) }

      let(:ccp_id) { lesson_part.lesson.unit.complete_curriculum_programme.id }
      let(:unit_id) { lesson_part.lesson.unit.id }
      let(:lesson_id) { lesson_part.lesson.id }

      parameter(name: :ccp_id, in: :path, type: :string, required: true)
      parameter(name: :unit_id, in: :path, type: :string, required: true)
      parameter(name: :lesson_id, in: :path, type: :string, required: true)

      response '200', 'lesson parts found' do
        examples('application/json': example_lesson_parts(2))

        schema(type: :array, items: { '$ref' => '#/components/schemas/lesson_part' })

        run_test!
      end
    end

    post('creates a lesson part belonging to the specified lesson') do
      tags('LessonPart')
      consumes 'application/json'

      let(:lesson_part) { FactoryBot.create(:lesson_part) }

      let(:ccp_id) { lesson_part.lesson.unit.complete_curriculum_programme.id }
      let(:unit_id) { lesson_part.lesson.unit.id }
      let(:lesson_id) { lesson_part.lesson.id }

      parameter(name: :ccp_id, in: :path, type: :string, required: true)
      parameter(name: :unit_id, in: :path, type: :string, required: true)
      parameter(name: :lesson_id, in: :path, type: :string, required: true)

      parameter(
        name: :lesson_part_params,
        in: :body,
        schema: {
          properties: {
            lesson_part: {
              '$ref' => '#/components/schemas/lesson_part', required: %i(lesson_part)
            }
          }
        }
      )

      request_body_json(
        schema: {
          properties: { '$ref' => '#/components/schemas/lesson_part', required: %i(lesson_part) }
        }
      )

      response(201, 'lesson created') do
        let!(:lesson_part_params) { { lesson_part: FactoryBot.attributes_for(:lesson_part) } }

        examples('application/json': { lesson_part: FactoryBot.attributes_for(:lesson_part) })

        run_test! do |response|
          JSON.parse(response.body).with_indifferent_access.tap do |json|
            lesson_part_params.dig(:lesson_part).each do |attribute, value|
              expect(json[attribute]).to eql(value)
            end
          end
        end
      end

      response(400, 'invalid lesson part') do
        let!(:lesson_part_params) { { lesson_part: FactoryBot.attributes_for(:lesson_part, position: nil) } }

        run_test! do |response|
          expect(JSON.parse(response.body).dig('errors')).to include(%(Position can't be blank))
        end
      end
    end
  end

  path('/ccps/{ccp_id}/units/{unit_id}/lessons/{lesson_id}/lesson_parts/{id}') do
    get('retrieves a single lesson part belonging to the specified CCP, unit and lesson') do
      tags('LessonPart')
      produces('application/json')

      let(:lesson_part) { FactoryBot.create(:lesson_part) }

      let(:ccp_id) { lesson_part.lesson.unit.complete_curriculum_programme.id }
      let(:unit_id) { lesson_part.lesson.unit.id }
      let(:lesson_id) { lesson_part.lesson.id }
      let(:id) { lesson_part.id }

      parameter(name: :ccp_id, in: :path, type: :string, required: true)
      parameter(name: :unit_id, in: :path, type: :string, required: true)
      parameter(name: :lesson_id, in: :path, type: :string, required: true)
      parameter(name: :id, in: :path, type: :string, required: true)

      request_body_json(
        schema: {
          properties: { '$ref' => '#/components/schemas/lesson_part', required: %i(lesson_part) }
        }
      )

      response('200', 'lesson part found') do
        examples('application/json': example_lesson_part)

        schema('$ref' => '#/components/schemas/lesson_part')

        run_test!
      end
    end

    patch('update the referenced lesson part') do
      tags('LessonPart')

      consumes 'application/json'

      let(:lesson_part) { FactoryBot.create(:lesson_part) }
      let(:lesson) { lesson_part.lesson }
      let(:unit) { lesson.unit }
      let(:ccp) { unit.complete_curriculum_programme }

      let(:id) { lesson_part.id }
      let(:lesson_id) { lesson.id }
      let(:unit_id) { unit.id }
      let(:ccp_id) { ccp.id }

      let(:lesson_part_params) { { lesson_part: FactoryBot.attributes_for(:lesson_part) } }

      parameter(name: :ccp_id, in: :path, type: :string, required: true)
      parameter(name: :unit_id, in: :path, type: :string, required: true)
      parameter(name: :lesson_id, in: :path, type: :string, required: true)
      parameter(name: :id, in: :path, type: :string, required: true)

      parameter(
        name: :lesson_part_params,
        in: :body,
        schema: {
          properties: {
            lesson_part: {
              '$ref' => '#/components/schemas/lesson_part', required: %i(lesson_part)
            }
          }
        }
      )

      request_body_json(schema: { '$ref' => '#/components/schemas/lesson_part' })

      response(200, 'lesson part updated') do
        examples('application/json': { lesson_part: FactoryBot.attributes_for(:lesson_part) })

        run_test! do |response|
          JSON.parse(response.body).with_indifferent_access.tap do |json|
            lesson_part_params.dig(:lesson_part).each do |attribute, value|
              expect(json[attribute]).to eql(value)
            end
          end
        end
      end

      response(400, 'invalid lesson part') do
        let(:lesson_part_params) { { lesson_part: FactoryBot.attributes_for(:lesson_part, position: nil) } }

        run_test! do |response|
          expect(JSON.parse(response.body).dig('errors')).to include(%(Position can't be blank))
        end
      end
    end
  end
end
