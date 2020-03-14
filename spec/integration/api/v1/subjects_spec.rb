require 'swagger_helper'

describe 'Subjects' do
  include_context 'setup api token'

  path('/subjects') do
    get('retrieves all subjects') do
      tags('Subject')
      produces('application/json')

      parameter(name: 'HTTP_API_TOKEN', in: :header, type: :string)

      let!(:subjects) { FactoryBot.create_list(:subject, 3) }

      response('200', 'all subjects found') do
        examples('application/json': example_subject)

        schema(type: :array, items: { '$ref' => '#/components/schemas/subject' })

        run_test! do |response|
          expected_names = subjects.map(&:name)
          actual_names = JSON.parse(response.body).map { |subject| subject.dig('name') }

          expect(actual_names).to match_array(expected_names)
        end
      end

      response(401, 'unauthorized') do
        it_should_behave_like 'an endpoint that requires token auth'
      end
    end
  end

  path('/subjects/{id}') do
    get('retrieves the specified subject') do
      tags('/ubjec')
      produces('application/json')

      let!(:maths) { FactoryBot.create(:subject, name: 'Maths') }

      parameter(name: 'HTTP_API_TOKEN', in: :header, type: :string)
      parameter(name: :id, in: :path, type: :string, required: true)

      response('200', 'with a valid id') do
        examples('application/json': example_subject)
        let(:id) { maths.id }

        schema('$ref' => '#/components/schemas/subject')

        run_test! do |response|
          expected_name = maths.name
          actual_name = JSON.parse(response.body).dig('name')

          expect(actual_name).to eql(expected_name)
        end
      end

      response('404', 'with a bad id') do
        examples('application/json': example_subject)

        schema('$ref' => '#/components/schemas/subject')
        let(:id) { 'magic' }

        run_test! do |response|
          expect(JSON.parse(response.body).dig('errors')).to eql(
            %(Subject #{id} not found)
          )
        end
      end

      response(401, 'unauthorized') do
        let(:id) { maths.id }

        it_should_behave_like 'an endpoint that requires token auth'
      end
    end
  end
end
