require 'rails_helper'

describe Teachers::ActivityChoicesController, type: :request do
  include_context 'logged in teacher'

  describe '#new' do
    let!(:lesson_part) { create(:lesson_part, :with_activities) }
    subject { get(new_teachers_lesson_part_choice_path(lesson_part)) }

    it { is_expected.to render_template('new') }
  end

  describe '#create' do
    let!(:lesson_part) { create(:lesson_part, :with_activities) }
    let(:chosen_activity) { lesson_part.activities.first }
    let(:activity_choice_params) { { activity_choice: { activity_id: chosen_activity.id } } }

    before { post(teachers_lesson_part_choice_path(lesson_part, activity_choice_params)) }

    specify 'should redirect to the lesson contents tab of the lesson page' do
      expect(response).to redirect_to(teachers_lesson_path(lesson_part.lesson, anchor: 'lesson-contents'))
    end

    specify 'an activity choice should be created' do
      expect(ActivityChoice.last).to have_attributes(activity: chosen_activity, teacher: teacher, lesson_part: lesson_part)
    end
  end

  describe '#edit' do
    let!(:lesson_part) { create(:lesson_part, :with_activities) }
    let!(:activity_choice) { create(:activity_choice, lesson_part: lesson_part, teacher: teacher) }

    subject { get(edit_teachers_lesson_part_choice_path(lesson_part)) }

    it { is_expected.to render_template('edit') }
  end

  describe '#update' do
    let(:activity_choice) { create(:activity_choice, teacher: teacher) }
    let(:chosen_activity) { create(:activity, lesson_part: activity_choice.lesson_part) }
    let(:lesson_part) { activity_choice.lesson_part }

    let(:activity_choice_params) { { activity_choice: { activity_id: chosen_activity.id } } }

    before { patch(teachers_lesson_part_choice_path(activity_choice.lesson_part, activity_choice_params)) }

    specify 'should redirect to the lesson contents tab of the lesson page' do
      expect(response).to redirect_to(teachers_lesson_path(lesson_part.lesson, anchor: 'lesson-contents'))
    end

    specify 'the activity choice should be updated' do
      expect(activity_choice.reload).to have_attributes(activity: chosen_activity, teacher: teacher, lesson_part: lesson_part)
    end
  end
end
