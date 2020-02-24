require "rails_helper"

RSpec.describe Api::V1::ActivitiesController, type: :request do
  let(:new_activity_name) { "Maths quiz" }

  describe '#create' do
    let(:lesson_part) { create(:lesson_part) }
    let(:lesson) { lesson_part.lesson }
    let(:unit) { lesson.unit }
    let(:ccp) { unit.complete_curriculum_programme }

    let(:path_args) { [ccp, unit, lesson, lesson_part] }

    subject do
      post(api_v1_ccp_unit_lesson_lesson_part_activities_path(*path_args, activity_params))
    end

    context 'when no teaching methods are provided' do
      let(:activity_params) { { activity: attributes_for(:activity) } }

      specify 'should create the activity with no teaching methods' do
        expect(subject).to be(201)
        expect(Activity.last.teaching_methods).to be_empty
      end
    end

    context 'when some teaching methods are provided' do
      let(:number_of_teaching_methods) { 2 }
      let(:teaching_methods) { create_list(:teaching_method, number_of_teaching_methods) }

      let(:activity_params) do
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

    let(:activity) { create(:activity) }
    let(:lesson_part) { activity.lesson_part }
    let(:lesson) { lesson_part.lesson }
    let(:unit) { lesson.unit }
    let(:ccp) { unit.complete_curriculum_programme }

    let(:existing_teaching_methods) { create_list(:teaching_method, number_of_teaching_methods) }
    before { activity.teaching_methods << existing_teaching_methods }

    let(:path_args) { [ccp, unit, lesson, lesson_part, activity] }

    subject do
      patch(api_v1_ccp_unit_lesson_lesson_part_activity_path(*path_args, activity_params))
    end

    context 'when an empty array of teaching methods is provided' do
      let(:activity_params) do
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

    context 'when an new array of teaching methods is provided' do
      let(:new_teaching_methods) { create_list(:teaching_method, number_of_teaching_methods) }

      let(:activity_params) do
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

    context 'when an new array of teaching methods is provided' do
      let(:activity_params) { { activity: { name: new_activity_name } } }

      specify 'should update the activity' do
        subject
        expect(activity.reload.name).to eql(new_activity_name)
      end

      specify 'should not change the existing teaching methods' do
        expect(activity.teaching_methods).to match_array(existing_teaching_methods)
        expect(subject).to be(200)
        expect(activity.teaching_methods).to match_array(existing_teaching_methods)
      end
    end
  end
end
