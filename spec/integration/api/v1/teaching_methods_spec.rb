require 'swagger_helper'

describe 'Teaching methods' do
  include_context 'setup api token'

  path('/teaching_methods') do
    get('retrieves all teaching methods') do
      tags('TeachingMethod')
      produces('application/json')

      parameter(name: 'Authorization', in: :header, type: :string)

      let!(:teaching_methods) { FactoryBot.create_list(:teaching_method, 3) }

      response('200', 'all teaching methods found') do
        examples('application/json': example_teaching_method)

        schema(type: :array, items: { '$ref' => '#/components/schemas/teaching_method' })

        run_test! do |response|
          expected_names = teaching_methods.map(&:name)
          actual_names = JSON.parse(response.body).map { |tm| tm.dig('name') }

          expect(actual_names).to match_array(expected_names)
        end
      end

      response(401, 'unauthorized') do
        it_should_behave_like 'an endpoint that requires token auth'
      end
    end
  end

  path('/teaching_methods/{id}') do
    get('retrieves the specified teaching method') do
      tags('TeachingMethod')
      produces('application/json')

      let!(:teaching_method) { FactoryBot.create(:teaching_method) }

      parameter(name: 'Authorization', in: :header, type: :string)
      parameter(name: :id, in: :path, type: :string, required: true)

      response('200', 'with a valid id') do
        examples('application/json': example_teaching_method)
        let(:id) { teaching_method.id }

        schema('$ref' => '#/components/schemas/teaching_method')

        run_test! do |response|
          expected_name = teaching_method.name
          actual_name = JSON.parse(response.body).dig('name')

          expect(actual_name).to eql(expected_name)
        end
      end

      response('404', 'with a bad id') do
        examples('application/json': example_teaching_method)

        schema('$ref' => '#/components/schemas/teaching_method')
        let(:id) { 'magic' }

        run_test! do |response|
          expect(JSON.parse(response.body).dig('errors')).to eql(
            %(Teaching method #{id} not found)
          )
        end
      end

      response(401, 'unauthorized') do
        let(:id) { teaching_method.id }

        it_should_behave_like 'an endpoint that requires token auth'
      end
    end
  end
end
