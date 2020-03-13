require "rails_helper"

RSpec.feature "Lesson contents tab", type: :feature do
  include_context 'logged in teacher'

  let(:lesson) { FactoryBot.create(:lesson) }
  let(:lesson_part_count) { 2 }
  let!(:lesson_parts) { create_list(:lesson_part, lesson_part_count, :with_activities, lesson: lesson) }

  before do
    visit(teachers_lesson_path(lesson))
    within('ol.govuk-tabs__list') { click_on 'Lesson plan' }
  end

  specify 'the page should contain a list of lesson parts' do
    expect(page).to have_css('.lesson-parts > .lesson-part')
  end

  specify 'all lesson parts belonging to the lesson should be listed' do
    within('.lesson-parts') do
      expect(page).to have_css('.lesson-part', count: lesson_part_count)
    end
  end

  # FIXME it would probably make sense to hide the link
  #       when there are no alternative activities
  specify 'each part should have a change link' do
    within('.lesson-parts') do
      lesson_parts.each do |lesson_part|
        expect(page).to have_link('Change activity', href: new_teachers_lesson_part_choice_path(lesson_part.id))
      end
    end
  end

  specify 'there should be a secondary button link to the downloads tab' do
    within('#lesson-contents') do
      expect(page).to have_link(
        '3.Download resources',
        href: teachers_lesson_path(lesson.id, anchor: 'downloads'),
        class: 'govuk-button--secondary'
      )
    end
  end
end
