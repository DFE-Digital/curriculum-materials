require 'rails_helper'

RSpec.feature "Lesson print", type: :feature do
  include_context 'logged in teacher'

  describe '#show' do
    let(:lesson) { FactoryBot.create(:lesson) }
    let(:lesson_part_count) { 2 }
    let!(:lesson_parts) { create_list(:lesson_part, lesson_part_count, :with_activities, lesson: lesson) }

    before { visit print_teachers_lesson_path(lesson) }

    specify "the page contains the lesson title" do
      expect(page).to have_content(lesson.name)
    end

    specify "the page contains the lesson activities" do
      expect(page).to have_css('table.lesson-parts.govuk-table')
    end

    specify "the page doesn't contain the ability to change activities" do
      expect(page).not_to have_text('Change activity')
    end
  end
end
