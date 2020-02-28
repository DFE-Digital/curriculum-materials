require 'rails_helper'

RSpec.feature "New activity choice", type: :feature do
  include_context 'logged in teacher'

  describe '#new' do
    let(:lesson_part) { create(:lesson_part) }

    let!(:default_activity) { create(:activity, lesson_part: lesson_part, default: true) }
    let!(:other_activities) { create_list(:activity, 2, lesson_part: lesson_part) }
    let(:all_activities) { other_activities.push(default_activity) }

    before { visit(new_teachers_lesson_part_choice_path(lesson_part)) }

    specify 'the heading should contain the lesson name and part number' do
      expect(page).to have_css(
        %(h1.govuk-fieldset__heading),
        text: "Choose an activity for #{lesson_part.lesson.name} part #{lesson_part.position}"
      )
    end

    specify 'the choices should be a list of radio buttons' do
      expect(page).to have_css(%(.govuk-radios__item), count: all_activities.size)
    end

    describe 'buttons' do
      specify %(the submit button should be labelled "Save lesson changes") do
        expect(page).to have_button('Save lesson changes')
      end

      specify 'the cancel button should take me back to the lesson contents' do
        expect(page).to have_link(
          'Cancel',
          href: teachers_lesson_path(lesson_part.lesson.id, anchor: 'lesson-contents')
        )
      end
    end

    specify 'the default activity should be selected' do
      expect(default_activity.default).to be(true)

      within(%(.activity[data-activity="#{default_activity.id}"])) do
        expect(page).to have_css(%(input[checked]))
      end
    end

    describe 'submitting the form' do
      let(:chosen_activity) { other_activities.first }

      specify 'choosing an activity and submitting the form should create an activity choice' do
        choose chosen_activity.name
        click_button 'Save lesson changes'

        expect(page.current_path).to eql(teachers_lesson_path(lesson_part.lesson.id))
        expect(ActivityChoice.last.activity).to eql(chosen_activity)
      end
    end
  end
end
