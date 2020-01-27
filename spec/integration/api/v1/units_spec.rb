require 'swagger_helper'

describe 'Units' do
  path('/ccps/{ccp_id}/units') do
    get('Retrieves all units belonging to the provided CCP') do
      tags('CCP')
      produces('application/json')

      let!(:ccp) { FactoryBot.create(:ccp) }
      let(:ccp_id) { ccp.id }
      let!(:units) { FactoryBot.create_list(:unit, 2, complete_curriculum_programme_id: ccp_id) }

      parameter(name: :ccp_id, in: :path, type: :string, required: true)

      response '200', 'units found' do
        examples('application/json': [example_units(2)])

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

  path('/ccps/{ccp_id}/units/{id}') do
    get('Retrieves a single unit belonging to the specified CCP') do
      tags('CCP')
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
            complete_curriculum_programme: example_ccp,
            lessons: example_lessons(3)
          )
        )

        schema(
          type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            benefits: { type: :string },
            overview: { type: :string },
            complete_curriculum_programme: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                benefits: { type: :string },
                overview: { type: :string }
              }
            },
            lessons: {
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
            }
          }
        )

        run_test!
      end
    end
  end
end
