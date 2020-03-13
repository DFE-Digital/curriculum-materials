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

      parameter name: 'HTTP_API_TOKEN', in: :header, type: :string
      parameter name: :ccp_id, in: :path, type: :string, required: true
      parameter name: :unit_id, in: :path, type: :string, required: true
      parameter name: :lesson_id, in: :path, type: :string, required: true
      parameter name: :lesson_part_id, in: :path, type: :string, required: true
      parameter name: :activity_id, in: :path, type: :string, required: true

      response '200', 'teacher resources found' do
        examples 'application/json': [{
          id: 1,
          url: 'https://example.com/path-to-resource'
        }]

        run_test!
      end
    end

    post 'Attaches a teacher resource to the activity' do
      tags 'TeacherResource'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'HTTP_API_TOKEN', in: :header, type: :string
      parameter name: :ccp_id, in: :path, type: :string, required: true
      parameter name: :unit_id, in: :path, type: :string, required: true
      parameter name: :lesson_id, in: :path, type: :string, required: true
      parameter name: :lesson_part_id, in: :path, type: :string, required: true
      parameter name: :activity_id, in: :path, type: :string, required: true
      parameter name: :teacher_resource, in: :formData, type: :file, required: true

      response 201, 'teacher_resouce created' do
        let :attachment_path do
          File.join(Rails.application.root, 'spec', 'fixtures', '1px.png')
        end

        let :teacher_resource do
          fixture_file_upload attachment_path, 'image/png'
        end

        request_body \
          content: {
            'multipart/form-data': {
              schema: {
                type: 'object',
                properties: {
                  teacher_resource: {
                    type: :string,
                    format: :binary
                  }
                }
              },
              encoding: {
                teacher_resource: {
                  contentType: Activity::ALLOWED_CONTENT_TYPES.join(',')
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

        let :teacher_resource do
          fixture_file_upload attachment_path, 'text/xml'
        end

        run_test! do |response|
          expect(response.code).to eq '400'

          expect(JSON.parse(response.body).dig('errors')).to include \
            "Teacher resources has an invalid content type"
        end
      end
    end
  end

  path '/ccps/{ccp_id}/units/{unit_id}/lessons/{lesson_id}/lesson_parts/{lesson_part_id}/activities/{activity_id}/teacher_resources/{teacher_resource_id}' do
    let :attachment_path do
      File.join(Rails.application.root, 'spec', 'fixtures', '1px.png')
    end

    let :teacher_resource do
      activity.teacher_resources.attach(
        io: File.open(attachment_path),
        filename: '1px.png',
        content_type: 'image/png'
      )
      activity.teacher_resources.last
    end

    let :teacher_resource_id do
      teacher_resource.id
    end

    delete %{Removes the attached resource from the activity} do
      tags 'TeacherResource'

      parameter name: 'HTTP_API_TOKEN', in: :header, type: :string
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
    end
  end
end
