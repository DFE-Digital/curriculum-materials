require "rails_helper"

RSpec.describe Api::V1::ActivitiesController, type: :request do
  include_context 'setup api token'

  let(:headers) { { headers: { HTTP_API_TOKEN: api_token } } }
  let(:new_activity_name) { "Maths quiz" }

  describe '#create' do
    let(:lesson_part) { create(:lesson_part) }
    let(:lesson) { lesson_part.lesson }
    let(:unit) { lesson.unit }
    let(:ccp) { unit.complete_curriculum_programme }

    let(:path_args) { [ccp, unit, lesson, lesson_part] }

    subject do
      post(
        api_v1_ccp_unit_lesson_lesson_part_activities_path(*path_args),
        **headers,
        params: params,
        as: :json,
      )
    end

    context 'when no teaching methods are provided' do
      let(:params) { { activity: attributes_for(:activity) } }

      specify 'should create the activity with no teaching methods' do
        expect(subject).to be(201)
        expect(Activity.last.teaching_methods).to be_empty
      end
    end

    context 'when some teaching methods are provided' do
      let(:number_of_teaching_methods) { 2 }
      let(:teaching_methods) { create_list(:teaching_method, number_of_teaching_methods) }

      let(:params) do
        {
          activity: attributes_for(:activity),
          teaching_methods: teaching_methods.map(&:name)
        }
      end

      specify 'should create the activity successfully with teaching methods attached' do
        expect(subject).to be(201)
        expect(Activity.last.teaching_methods.count).to eql(number_of_teaching_methods)
      end
    end
  end

  describe '#update' do
    let(:number_of_teaching_methods) { 2 }

    let(:original_activity_name) { 'Some activity' }
    let(:activity) { create(:activity, name: original_activity_name) }
    let(:lesson_part) { activity.lesson_part }
    let(:lesson) { lesson_part.lesson }
    let(:unit) { lesson.unit }
    let(:ccp) { unit.complete_curriculum_programme }

    let(:existing_teaching_methods) { create_list(:teaching_method, number_of_teaching_methods) }
    before { activity.teaching_methods << existing_teaching_methods }

    let(:path_args) { [ccp, unit, lesson, lesson_part, activity] }

    subject do
      patch(
        api_v1_ccp_unit_lesson_lesson_part_activity_path(*path_args),
        **headers,
        params: params,
        as: :json
      )
    end

    context 'when an empty array of teaching methods is provided' do
      let(:params) do
        {
          activity: { name: new_activity_name },
          teaching_methods: []
        }
      end

      specify 'should update the activity name' do
        subject
        expect(activity.reload.name).to eql(new_activity_name)
      end

      specify 'should clear the existing teaching methods' do
        expect(activity.teaching_methods).to match_array(existing_teaching_methods)
        expect(subject).to be(200)
        expect(activity.reload.teaching_methods).to be_empty
      end
    end

    context 'when a new array of teaching methods is provided' do
      let(:new_teaching_methods) { create_list(:teaching_method, number_of_teaching_methods) }

      let(:params) do
        {
          activity: { name: new_activity_name },
          teaching_methods: new_teaching_methods.map(&:name)
        }
      end

      specify 'should update the activity name' do
        subject
        expect(activity.reload.name).to eql(new_activity_name)
      end

      specify 'should assign the provided teaching methods' do
        expect(activity.teaching_methods).to match_array(existing_teaching_methods)
        expect(subject).to be(200)
        expect(activity.reload.teaching_methods).to match_array(new_teaching_methods)
      end
    end

    context 'when no teaching methods are provided' do
      let(:params) { { activity: { name: new_activity_name } } }

      specify 'should update the activity' do
        subject
        expect(activity.reload.name).to eql(new_activity_name)
      end

      specify 'should not change the existing teaching methods' do
        expect(activity.teaching_methods).to match_array(existing_teaching_methods)
        expect(subject).to be(200)
        expect(activity.reload.teaching_methods).to match_array(existing_teaching_methods)
      end
    end

    context 'when a teaching method that does not exist is provided' do
      let(:invalid_teaching_method) { 'Vulcan mind meld' }
      let(:params) do
        {
          activity: attributes_for(:activity),
          teaching_methods: [invalid_teaching_method]
        }
      end

      specify 'should not update the activity' do
        expect(subject).to be(400)
        expect(activity.reload.name).to eql(original_activity_name)
      end

      specify 'the error message should contain the invalid teaching method' do
        subject

        JSON.parse(response.body).dig('errors').tap do |error_message|
          expect(error_message).to include('Invalid teaching method')
          expect(error_message).to include(invalid_teaching_method)
        end
      end
    end
  end
end
