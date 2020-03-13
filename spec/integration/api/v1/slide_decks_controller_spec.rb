require 'swagger_helper'

describe 'Slide decks' do
  include_context 'setup api token'

  let(:activity) { create(:activity) }
  let(:ccp_id) { activity.lesson_part.lesson.unit.complete_curriculum_programme.id }
  let(:unit_id) { activity.lesson_part.lesson.unit.id }
  let(:lesson_id) { activity.lesson_part.lesson.id }
  let(:lesson_part_id) { activity.lesson_part.id }
  let(:activity_id) { activity.id }

  path '/ccps/{ccp_id}/units/{unit_id}/lessons/{lesson_id}/lesson_parts/{lesson_part_id}/activities/{activity_id}/slide_deck' do
    post %{Attaches a slide deck to the activity} do
      let :slide_deck_path do
        File.join(Rails.application.root, 'spec', 'fixtures', 'slide_1_keyword_match_up.odp')
      end

      let :slide_deck_preview_path do
        File.join(Rails.application.root, 'spec', 'fixtures', '1px.png')
      end

      let 'slide_deck_resource[file]' do
        fixture_file_upload slide_deck_path, 'application/vnd.oasis.opendocument.presentation'
      end

      let 'slide_deck_resource[preview]' do
        fixture_file_upload slide_deck_preview_path, 'image/png'
      end

      tags 'SlideDeckResource'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'Authorization', in: :header, type: :string
      parameter name: :ccp_id, in: :path, type: :string, required: true
      parameter name: :unit_id, in: :path, type: :string, required: true
      parameter name: :lesson_id, in: :path, type: :string, required: true
      parameter name: :lesson_part_id, in: :path, type: :string, required: true
      parameter name: :activity_id, in: :path, type: :string, required: true
      parameter name: 'slide_deck_resource[file]', in: :formData, type: :file, required: true
      parameter name: 'slide_deck_resource[preview]', in: :formData, type: :file, required: true

      response 201, 'slide_deck_resource created' do
        request_body \
          content: {
            'multipart/form-data': {
              schema: {
                type: 'object',
                properties: {
                  'slide_deck_resource[file]': {
                    type: :string,
                    format: :binary
                  },
                  'slide_deck_resource[preview]': {
                    type: :string,
                    format: :binary
                  }
                }
              },
              encoding: {
                'slide_deck_resource[file]': {
                  contentType: SlideDeckResource::ALLOWED_CONTENT_TYPES
                },
                'slide_deck_resource[preview]': {
                  contentType: SlideDeckResource::ALLOWED_PREVIEW_CONTENT_TYPES
                }
              }
            }
          }

        run_test! do |response|
          expect(response.code).to eq '201'
          expect(activity.reload.slide_deck_resource).to be_persisted
          expect(activity.reload.slide_deck_resource.file).to be_attached
          expect(activity.reload.slide_deck_resource.preview).to be_attached
          expect(activity.reload.slide_deck_resource.file.download).to eq File.binread slide_deck_path
          expect(activity.reload.slide_deck_resource.preview.download).to eq File.binread slide_deck_preview_path
        end
      end

      response(401, 'unauthorized') do
        it_should_behave_like 'an endpoint that requires token auth'
      end
    end

    get %{Returns the slide deck for an activity} do
      tags 'SlideDeckResource'
      produces 'application/json'

      parameter name: 'Authorization', in: :header, type: :string
      parameter name: :ccp_id, in: :path, type: :string, required: true
      parameter name: :unit_id, in: :path, type: :string, required: true
      parameter name: :lesson_id, in: :path, type: :string, required: true
      parameter name: :lesson_part_id, in: :path, type: :string, required: true
      parameter name: :activity_id, in: :path, type: :string, required: true

      let! :slide_deck_resource do
        create :slide_deck_resource, :with_preview, activity: activity
      end

      response '200', 'slide deck found' do
        examples 'application/json': {
          id: 1,
          file_url: 'https://example.com/path-to-resource',
          preview_url: 'https://example.com/path-to-resource'
        }
        run_test!
      end

      response(401, 'unauthorized') do
        it_should_behave_like 'an endpoint that requires token auth'
      end
    end

    delete %{Removes the slide deck for an activity} do
      tags 'SlideDeckResource'

      parameter name: 'Authorization', in: :header, type: :string
      parameter name: :ccp_id, in: :path, type: :string, required: true
      parameter name: :unit_id, in: :path, type: :string, required: true
      parameter name: :lesson_id, in: :path, type: :string, required: true
      parameter name: :lesson_part_id, in: :path, type: :string, required: true
      parameter name: :activity_id, in: :path, type: :string, required: true

      let! :slide_deck_resource do
        create :slide_deck_resource, activity: activity
      end

      response '204', 'slide deck removed' do
        run_test! do |response|
          expect(response.code).to eq '204'
          expect(activity.reload.slide_deck_resource).not_to be_present
        end
      end

      response(401, 'unauthorized') do
        it_should_behave_like 'an endpoint that requires token auth'
      end
    end
  end
end
