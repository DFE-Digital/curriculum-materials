require 'rails_helper'

RSpec.feature "Edit activity choice", type: :feature do
  include_context 'logged in teacher'

  describe '#edit' do
    let(:lesson_part) { create(:lesson_part) }

    let(:previously_selected_activity) { create(:activity, lesson_part: lesson_part, default: true) }
    let(:activities) { create_list(:activity, 2, lesson_part: lesson_part) }
    let(:chosen_activity) { activities.first }

    let!(:activity_choice) do
      create(
        :activity_choice,
        lesson_part: lesson_part,
        activity: chosen_activity,
        teacher: teacher
      )
    end

    before { visit(edit_teachers_lesson_part_choice_path(lesson_part)) }

    specify 'the current activity should be selected' do
      within(%(.activity[data-activity="#{chosen_activity.id}"])) do
        expect(page).to have_css(%(input[checked]))
      end
    end

    describe 'submitting the form' do
      specify 'choosing an activity and submitting the form should create an activity choice' do
        choose chosen_activity.name
        click_button 'Save lesson changes'

        expect(page.current_path).to eql(teachers_lesson_path(lesson_part.lesson.id))
        expect(ActivityChoice.last.activity).to eql(chosen_activity)
      end
    end
  end
end
