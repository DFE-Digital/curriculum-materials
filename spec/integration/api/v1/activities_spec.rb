require 'swagger_helper'

describe 'Activities' do
  include_context 'setup api token'

  path('/ccps/{ccp_id}/units/{unit_id}/lessons/{lesson_id}/lesson_parts/{lesson_part_id}/activities') do
    get('retrieves all activities belonging to the specified lesson part') do
      tags('Activity')
      produces('application/json')

      let(:activity) { FactoryBot.create(:activity) }

      let(:ccp_id) { activity.lesson_part.lesson.unit.complete_curriculum_programme.id }
      let(:unit_id) { activity.lesson_part.lesson.unit.id }
      let(:lesson_id) { activity.lesson_part.lesson.id }
      let(:lesson_part_id) { activity.lesson_part.id }

      parameter(name: 'Authorization', in: :header, type: :string)
      parameter(name: :ccp_id, in: :path, type: :string, required: true)
      parameter(name: :unit_id, in: :path, type: :string, required: true)
      parameter(name: :lesson_id, in: :path, type: :string, required: true)
      parameter(name: :lesson_part_id, in: :path, type: :string, required: true)

      response '200', 'activities found' do
        examples('application/json': example_activities(2))

        schema(type: :array, items: { '$ref' => '#/components/schemas/activity' })

        run_test!
      end

      response(401, 'unauthorized') do
        it_should_behave_like 'an endpoint that requires token auth'
      end
    end

    post('creates an activity belonging to the specified lesson part') do
      tags('Activity')
      consumes 'application/json'

      let(:activity) { FactoryBot.create(:activity) }

      let(:ccp_id) { activity.lesson_part.lesson.unit.complete_curriculum_programme.id }
      let(:unit_id) { activity.lesson_part.lesson.unit.id }
      let(:lesson_id) { activity.lesson_part.lesson.id }
      let(:lesson_part_id) { activity.lesson_part.id }
      let(:id) { activity.id }

      parameter(name: 'Authorization', in: :header, type: :string)
      parameter(name: :ccp_id, in: :path, type: :string, required: true)
      parameter(name: :unit_id, in: :path, type: :string, required: true)
      parameter(name: :lesson_id, in: :path, type: :string, required: true)
      parameter(name: :lesson_part_id, in: :path, type: :string, required: true)

      parameter(
        name: :activity_params,
        in: :body,
        schema: {
          properties: {
            activity: {
              '$ref' => '#/components/schemas/activity', required: %i(activity)
            },
            teaching_methods: {
              '$ref' => '#/components/schemas/teaching_methods'
            }
          }
        }
      )

      request_body_json(
        schema: {
          properties: { '$ref' => '#/components/schemas/activity', required: %i(activity) }
        }
      )

      response(201, 'activity created') do
        let!(:activity_params) { { activity: FactoryBot.attributes_for(:activity, default: true) } }

        examples('application/json': { activity: FactoryBot.attributes_for(:activity, default: true).merge(teaching_methods: example_teaching_methods(2)) })

        run_test! do |response|
          JSON.parse(response.body).with_indifferent_access.tap do |json|
            activity_params.dig(:activity).each do |attribute, value|
              expect(json[attribute]).to eql(value)
            end
          end
        end
      end

      response(400, 'invalid lesson part') do
        let!(:activity_params) { { activity: FactoryBot.attributes_for(:activity, duration: nil) } }

        run_test! do |response|
          expect(JSON.parse(response.body).dig('errors')).to include(%(Duration can't be blank))
        end
      end

      response(401, 'unauthorized') do
        it_should_behave_like 'an endpoint that requires token auth'
      end
    end
  end

  path('/ccps/{ccp_id}/units/{unit_id}/lessons/{lesson_id}/lesson_parts/{lesson_part_id}/activities/{id}') do
    get('retrieves a single activity belonging to the specified lesson part') do
      tags('Activity')
      produces('application/json')

      let(:activity) { FactoryBot.create(:activity) }

      let(:ccp_id) { activity.lesson_part.lesson.unit.complete_curriculum_programme.id }
      let(:unit_id) { activity.lesson_part.lesson.unit.id }
      let(:lesson_id) { activity.lesson_part.lesson.id }
      let(:lesson_part_id) { activity.lesson_part.id }
      let(:id) { activity.id }

      parameter(name: 'Authorization', in: :header, type: :string)
      parameter(name: :ccp_id, in: :path, type: :string, required: true)
      parameter(name: :unit_id, in: :path, type: :string, required: true)
      parameter(name: :lesson_id, in: :path, type: :string, required: true)
      parameter(name: :lesson_part_id, in: :path, type: :string, required: true)
      parameter(name: :id, in: :path, type: :string, required: true)

      response('200', 'activity found') do
        examples('application/json': example_activity.merge(teaching_methods: example_teaching_methods(2)))

        schema('$ref' => '#/components/schemas/activity')

        run_test!
      end

      response(401, 'unauthorized') do
        it_should_behave_like 'an endpoint that requires token auth'
      end
    end

    patch('update the referenced activity') do
      tags('Activity')

      consumes 'application/json'

      let(:activity) { FactoryBot.create(:activity) }

      let(:ccp_id) { activity.lesson_part.lesson.unit.complete_curriculum_programme.id }
      let(:unit_id) { activity.lesson_part.lesson.unit.id }
      let(:lesson_id) { activity.lesson_part.lesson.id }
      let(:lesson_part_id) { activity.lesson_part.id }
      let(:id) { activity.id }

      let(:activity_params) { { activity: FactoryBot.attributes_for(:activity) } }

      parameter(name: 'Authorization', in: :header, type: :string)
      parameter(name: :ccp_id, in: :path, type: :string, required: true)
      parameter(name: :unit_id, in: :path, type: :string, required: true)
      parameter(name: :lesson_id, in: :path, type: :string, required: true)
      parameter(name: :lesson_part_id, in: :path, type: :string, required: true)
      parameter(name: :id, in: :path, type: :string, required: true)

      parameter(
        name: :activity_params,
        in: :body,
        schema: {
          properties: {
            activity: {
              '$ref' => '#/components/schemas/activity', required: %i(activity)
            },
            teaching_methods: {
              '$ref' => '#/components/schemas/teaching_methods'
            }
          }
        }
      )

      request_body_json(schema: { '$ref' => '#/components/schemas/activity' })

      response(200, 'activity updated') do
        examples('application/json': { activity: FactoryBot.attributes_for(:activity).merge(teaching_methods: example_teaching_methods(2)) })

        run_test! do |response|
          JSON.parse(response.body).with_indifferent_access.tap do |json|
            activity_params.dig(:activity).each do |attribute, value|
              expect(json[attribute]).to eql(value)
            end
          end
        end
      end

      response(400, 'invalid lesson part') do
        let(:activity_params) { { activity: FactoryBot.attributes_for(:activity, duration: nil) } }

        run_test! do |response|
          expect(JSON.parse(response.body).dig('errors')).to include(%(Duration can't be blank))
        end
      end

      response(401, 'unauthorized') do
        it_should_behave_like 'an endpoint that requires token auth'
      end
    end
  end
end
