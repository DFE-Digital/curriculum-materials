require 'rails_helper'

RSpec.feature "New activity choice", type: :feature do
  include_context 'logged in teacher'

  describe '#new' do
    let(:lesson_part) { create(:lesson_part) }

    let!(:default_activity) { create(:activity, lesson_part:lesson_part, default: true) }
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

    specify 'the default activity should be selected' do
      expect(default_activity.default).to be(true)

      within(%(.activity[data-activity="#{default_activity.id}"])) do
        expect(page).to have_css(%(input[checked]))
      end
    end
  end
end
