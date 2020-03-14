require 'swagger_helper'

describe 'Slide decks' do
  include_context 'setup api token'

  let(:activity) { create(:activity) }
  let(:ccp_id) { activity.lesson_part.lesson.unit.complete_curriculum_programme.id }
  let(:unit_id) { activity.lesson_part.lesson.unit.id }
  let(:lesson_id) { activity.lesson_part.lesson.id }
  let(:lesson_part_id) { activity.lesson_part.id }
  let(:activity_id) { activity.id }

  let :slide_deck_path do
    File.join(Rails.application.root, 'spec', 'fixtures', 'slide_1_keyword_match_up.odp')
  end

  let :slide_deck do
    fixture_file_upload slide_deck_path, 'application/vnd.oasis.opendocument.presentation'
  end

  path '/ccps/{ccp_id}/units/{unit_id}/lessons/{lesson_id}/lesson_parts/{lesson_part_id}/activities/{activity_id}/slide_deck' do
    post %{Attaches a slide deck to the activity} do
      tags 'SlideDeck'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'HTTP_API_TOKEN', in: :header, type: :string
      parameter name: :ccp_id, in: :path, type: :string, required: true
      parameter name: :unit_id, in: :path, type: :string, required: true
      parameter name: :lesson_id, in: :path, type: :string, required: true
      parameter name: :lesson_part_id, in: :path, type: :string, required: true
      parameter name: :activity_id, in: :path, type: :string, required: true
      parameter name: :slide_deck, in: :formData, type: :file, required: true

      response 201, 'slide_deck created' do
        request_body \
          content: {
            'multipart/form-data': {
              schema: {
                type: 'object',
                properties: {
                  slide_deck: {
                    type: :string,
                    format: :binary
                  }
                }
              },
              encoding: {
                slide_deck: {
                  contentType: Activity::SLIDE_DECK_CONTENT_TYPE
                }
              }
            }
          }

        run_test! do |response|
          expect(response.code).to eq '201'
          expect(activity.reload.slide_deck).to be_attached
          expect(activity.reload.slide_deck.download).to eq \
            File.binread slide_deck_path
        end
      end

      response(401, 'unauthorized') do
        it_should_behave_like 'an endpoint that requires token auth'
      end
    end

    get %{Returns the slide deck for an activity} do
      tags 'SlideDeck'
      produces 'application/json'

      parameter name: 'HTTP_API_TOKEN', in: :header, type: :string
      parameter name: :ccp_id, in: :path, type: :string, required: true
      parameter name: :unit_id, in: :path, type: :string, required: true
      parameter name: :lesson_id, in: :path, type: :string, required: true
      parameter name: :lesson_part_id, in: :path, type: :string, required: true
      parameter name: :activity_id, in: :path, type: :string, required: true

      before do
        activity.slide_deck.attach \
          io: File.open(slide_deck_path),
          filename: 'slide_1_keyword_match_up.odp',
          content_type: 'application/vnd.oasis.opendocument.presentation'
      end

      response '200', 'slide deck found' do
        examples 'application/json': {
          id: 1,
          url: 'https://example.com/path-to-resource'
        }
        run_test!
      end

      response(401, 'unauthorized') do
        it_should_behave_like 'an endpoint that requires token auth'
      end
    end

    delete %{Removes the slide deck for an activity} do
      tags 'SlideDeck'

      parameter name: 'HTTP_API_TOKEN', in: :header, type: :string
      parameter name: :ccp_id, in: :path, type: :string, required: true
      parameter name: :unit_id, in: :path, type: :string, required: true
      parameter name: :lesson_id, in: :path, type: :string, required: true
      parameter name: :lesson_part_id, in: :path, type: :string, required: true
      parameter name: :activity_id, in: :path, type: :string, required: true

      before do
        activity.slide_deck.attach \
          io: File.open(slide_deck_path),
          filename: 'slide_1_keyword_match_up.odp',
          content_type: 'application/vnd.oasis.opendocument.presentation'
      end

      response '204', 'slide deck removed' do
        run_test! do |response|
          expect(response.code).to eq '204'
          expect(activity.reload.slide_deck).not_to be_attached
        end
      end

      response(401, 'unauthorized') do
        it_should_behave_like 'an endpoint that requires token auth'
      end
    end
  end
end
