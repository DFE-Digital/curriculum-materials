require 'swagger_helper'

describe 'Lessons' do
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
        examples('application/json': example_lessons(2))

        schema(type: :array, items: { '$ref' => '#/components/schemas/lesson_part' })

        run_test!
      end
    end
  end
end
