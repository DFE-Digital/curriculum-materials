require 'swagger_helper'

describe 'Lessons' do
  path('/ccps/{ccp_id}/units/{unit_id}/lessons') do
    get('Retrieves all lessons belonging to the specified CCP and unit') do
      tags('CCP')
      produces('application/json')

      let(:lesson) { FactoryBot.create(:lesson) }

      let(:ccp_id) { lesson.unit.complete_curriculum_programme.id }
      let(:unit_id) { lesson.unit.id }

      parameter(name: :ccp_id, in: :path, type: :string, required: true)
      parameter(name: :unit_id, in: :path, type: :string, required: true)

      response '200', 'lessons found' do
        examples('application/json': [example_lessons(2)])

        schema(
          type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              summary: { type: :string },
              core_knowledge: { type: :string },
              previous_knowledge: { type: :string },
              vocabulary: {
                type: :array, items: { type: :string }
              },
              misconceptions: {
                type: :array, items: { type: :string }
              },
            }
          }
        )

        run_test!
      end
    end
  end

  path('/ccps/{ccp_id}/units/{unit_id}/lessons/{id}') do
    get('Retrieves a single lesson belonging to the specified CCP and unit') do
      tags('CCP')
      produces('application/json')

      let(:lesson) { FactoryBot.create(:lesson) }

      let(:ccp_id) { lesson.unit.complete_curriculum_programme.id }
      let(:unit_id) { lesson.unit.id }
      let(:id) { lesson.id }


      parameter(name: :ccp_id, in: :path, type: :string, required: true)
      parameter(name: :unit_id, in: :path, type: :string, required: true)
      parameter(name: :id, in: :path, type: :string, required: true)

      response('200', 'lesson found') do
        examples('application/json': example_lesson)

        schema(
          type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            summary: { type: :string },
            core_knowledge: { type: :string },
            previous_knowledge: { type: :string },
            vocabulary: {
              type: :array, items: { type: :string }
            },
            misconceptions: {
              type: :array, items: { type: :string }
            }
          }
        )

        run_test!
      end
    end
  end
end
