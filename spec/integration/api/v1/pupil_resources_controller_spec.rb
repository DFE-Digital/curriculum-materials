require 'swagger_helper'

describe 'PupilResources' do
  let(:activity) { create(:activity) }
  let(:ccp_id) { activity.lesson_part.lesson.unit.complete_curriculum_programme.id }
  let(:unit_id) { activity.lesson_part.lesson.unit.id }
  let(:lesson_id) { activity.lesson_part.lesson.id }
  let(:lesson_part_id) { activity.lesson_part.id }
  let(:activity_id) { activity.id }

  path '/ccps/{ccp_id}/units/{unit_id}/lessons/{lesson_id}/lesson_parts/{lesson_part_id}/activities/{activity_id}/pupil_resources' do
    get %{Returns the activity's attached pupil_resources} do
      tags 'PupilResource'
      produces 'application/json'
      parameter name: :ccp_id, in: :path, type: :string, required: true
      parameter name: :unit_id, in: :path, type: :string, required: true
      parameter name: :lesson_id, in: :path, type: :string, required: true
      parameter name: :lesson_part_id, in: :path, type: :string, required: true
      parameter name: :activity_id, in: :path, type: :string, required: true

      response '200', 'pupil resources found' do
        examples 'application/json': [{
          id: 1,
          url: 'https://example.com/path-to-resource'
        }]

        run_test!
      end
    end

    post 'Attaches a pupil resource to the activity' do
      tags 'PupilResource'
      consumes 'multipart/form-data'
      produces 'application/json'
      parameter name: :ccp_id, in: :path, type: :string, required: true
      parameter name: :unit_id, in: :path, type: :string, required: true
      parameter name: :lesson_id, in: :path, type: :string, required: true
      parameter name: :lesson_part_id, in: :path, type: :string, required: true
      parameter name: :activity_id, in: :path, type: :string, required: true
      parameter name: :pupil_resource, in: :formData, type: :file, required: true

      response 201, 'pupil_resouce created' do
        let :attachment_path do
          File.join(Rails.application.root, 'spec', 'fixtures', '1px.png')
        end

        let :pupil_resource do
          fixture_file_upload attachment_path, 'image/png'
        end

        request_body \
          content: {
            'multipart/form-data': {
              schema: {
                type: 'object',
                properties: {
                  pupil_resource: {
                    type: :string,
                    format: :binary
                  }
                }
              },
              encoding: {
                pupil_resource: {
                  contentType: Activity::ALLOWED_CONTENT_TYPES.join(',')
                }
              }
            }
          }

        run_test! do |response|
          expect(response.code).to eq '201'
        end
      end

      response 400, 'invalid pupil_resource' do
        let :attachment_path do
          File.join(Rails.application.root, 'spec', 'fixtures', 'sample.xml')
        end

        let :pupil_resource do
          fixture_file_upload attachment_path, 'text/xml'
        end

        run_test! do |response|
          expect(response.code).to eq '400'

          expect(JSON.parse(response.body).dig('errors')).to include \
            "Pupil resources has an invalid content type"
        end
      end
    end
  end
end
