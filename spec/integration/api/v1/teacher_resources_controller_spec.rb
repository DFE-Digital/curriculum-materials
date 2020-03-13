require 'swagger_helper'

describe 'TeacherResources' do
  include_context 'setup api token'

  let(:activity) { create(:activity) }
  let(:ccp_id) { activity.lesson_part.lesson.unit.complete_curriculum_programme.id }
  let(:unit_id) { activity.lesson_part.lesson.unit.id }
  let(:lesson_id) { activity.lesson_part.lesson.id }
  let(:lesson_part_id) { activity.lesson_part.id }
  let(:activity_id) { activity.id }

  path '/ccps/{ccp_id}/units/{unit_id}/lessons/{lesson_id}/lesson_parts/{lesson_part_id}/activities/{activity_id}/teacher_resources' do
    get %{Returns the activity's attached teacher_resources} do
      tags 'TeacherResource'
      produces 'application/json'

      parameter name: 'Authorization', in: :header, type: :string
      parameter name: :ccp_id, in: :path, type: :string, required: true
      parameter name: :unit_id, in: :path, type: :string, required: true
      parameter name: :lesson_id, in: :path, type: :string, required: true
      parameter name: :lesson_part_id, in: :path, type: :string, required: true
      parameter name: :activity_id, in: :path, type: :string, required: true

      response '200', 'teacher resources found' do
        examples 'application/json': [{
          id: 1,
          file_url: 'https://example.com/path-to-resource',
          preview_url: 'https://example.com/path-to-resource'
        }]

        run_test!
      end

      response(401, 'unauthorized') do
        it_should_behave_like 'an endpoint that requires token auth'
      end
    end

    post 'Attaches a teacher resource to the activity' do
      tags 'TeacherResource'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'Authorization', in: :header, type: :string
      parameter name: :ccp_id, in: :path, type: :string, required: true
      parameter name: :unit_id, in: :path, type: :string, required: true
      parameter name: :lesson_id, in: :path, type: :string, required: true
      parameter name: :lesson_part_id, in: :path, type: :string, required: true
      parameter name: :activity_id, in: :path, type: :string, required: true
      parameter name: 'teacher_resource[file]', in: :formData, type: :file, required: true
      parameter name: 'teacher_resource[preview]', in: :formData, type: :file, required: true

      response 201, 'teacher_resouce created' do
        let :attachment_path do
          File.join(Rails.application.root, 'spec', 'fixtures', '1px.png')
        end

        let 'teacher_resource[file]' do
          fixture_file_upload attachment_path, 'image/png'
        end

        let 'teacher_resource[preview]' do
          fixture_file_upload attachment_path, 'image/png'
        end

        request_body \
          content: {
            'multipart/form-data': {
              schema: {
                type: 'object',
                properties: {
                  'teacher_resource[file]': {
                    type: :string,
                    format: :binary
                  },
                  'teacher_resource[preview]': {
                    type: :string,
                    format: :binary
                  }
                }
              },
              encoding: {
                'teacher_resource[file]': {
                  contentType: TeacherResource::ALLOWED_CONTENT_TYPES.join(',')
                },
                'teacher_resource[preview]': {
                  contentType: TeacherResource::ALLOWED_PREVIEW_CONTENT_TYPES.join(',')
                }
              }
            }
          }

        run_test! do |response|
          expect(response.code).to eq '201'
        end
      end

      response 400, 'invalid teacher_resource' do
        let :attachment_path do
          File.join(Rails.application.root, 'spec', 'fixtures', 'sample.xml')
        end

        let 'teacher_resource[file]' do
          fixture_file_upload attachment_path, 'text/xml'
        end

        let 'teacher_resource[preview]' do
          fixture_file_upload attachment_path, 'text/xml'
        end

        run_test! do |response|
          expect(response.code).to eq '400'

          expect(JSON.parse(response.body).dig('errors')).to include \
            "File has an invalid content type"
        end
      end

      response(401, 'unauthorized') do
        let :attachment_path do
          File.join(Rails.application.root, 'spec', 'fixtures', 'sample.xml')
        end

        let 'teacher_resource[file]' do
          fixture_file_upload attachment_path, 'image/png'
        end

        let 'teacher_resource[preview]' do
          fixture_file_upload attachment_path, 'image/png'
        end

        it_should_behave_like 'an endpoint that requires token auth'
      end
    end
  end

  path '/ccps/{ccp_id}/units/{unit_id}/lessons/{lesson_id}/lesson_parts/{lesson_part_id}/activities/{activity_id}/teacher_resources/{teacher_resource_id}' do
    let :teacher_resource do
      create :teacher_resource, :with_file, activity: activity
    end

    let :teacher_resource_id do
      teacher_resource.id
    end

    delete %{Removes the attached resource from the activity} do
      tags 'TeacherResource'

      parameter name: 'Authorization', in: :header, type: :string
      parameter name: :ccp_id, in: :path, type: :string, required: true
      parameter name: :unit_id, in: :path, type: :string, required: true
      parameter name: :lesson_id, in: :path, type: :string, required: true
      parameter name: :lesson_part_id, in: :path, type: :string, required: true
      parameter name: :activity_id, in: :path, type: :string, required: true
      parameter name: :teacher_resource_id, in: :path, type: :string, required: true

      response '204', 'teacher resource removed' do
        run_test! do |response|
          expect(response.code).to eq '204'
          expect(activity.reload.teacher_resources).to be_empty
        end
      end

      response(401, 'unauthorized') do
        it_should_behave_like 'an endpoint that requires token auth'
      end
    end
  end
end
