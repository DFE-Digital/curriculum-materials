require 'swagger_helper'

describe 'Activities' do
  path('/ccps/{ccp_id}/units/{unit_id}/lessons/{lesson_id}/lesson_parts/{lesson_part_id}/activities') do
    get('retrieves all activities belonging to the specified lesson part') do
      tags('Activity')
      produces('application/json')

      let(:activity) { FactoryBot.create(:activity) }

      let(:ccp_id) { activity.lesson_part.lesson.unit.complete_curriculum_programme.id }
      let(:unit_id) { activity.lesson_part.lesson.unit.id }
      let(:lesson_id) { activity.lesson_part.lesson.id }
      let(:lesson_part_id) { activity.lesson_part.id }

      parameter(name: :ccp_id, in: :path, type: :string, required: true)
      parameter(name: :unit_id, in: :path, type: :string, required: true)
      parameter(name: :lesson_id, in: :path, type: :string, required: true)
      parameter(name: :lesson_part_id, in: :path, type: :string, required: true)

      response '200', 'activities found' do
        examples('application/json': example_activities(2))

        schema(type: :array, items: { '$ref' => '#/components/schemas/activity' })

        run_test!
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

      parameter(name: :ccp_id, in: :path, type: :string, required: true)
      parameter(name: :unit_id, in: :path, type: :string, required: true)
      parameter(name: :lesson_id, in: :path, type: :string, required: true)
      parameter(name: :lesson_part_id, in: :path, type: :string, required: true)
      parameter(name: :id, in: :path, type: :string, required: true)

      response('200', 'activity found') do
        examples('application/json': example_activity)

        schema('$ref' => '#/components/schemas/activity')

        run_test!
      end
    end
  end
end
