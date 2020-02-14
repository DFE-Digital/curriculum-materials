require "rails_helper"

RSpec.feature "Lesson contents tab", type: :feature do
  include_context 'logged in teacher'

  let(:lesson) { FactoryBot.create(:lesson) }
  let(:lesson_part_count) { 2 }
  let!(:lesson_part) { create_list(:lesson_part, lesson_part_count, :with_activities, lesson: lesson) }

  before do
    visit(teachers_lesson_path(lesson))
    click_on 'Lesson contents'
  end

  specify 'the page should contain a table of lesson parts' do
    expect(page).to have_css('table.lesson-parts')
  end

  specify 'there should be one row per lesson part' do
    within('table.lesson-parts > tbody') do
      expect(page).to have_css('tr', count: lesson_part_count)
    end
  end
end
