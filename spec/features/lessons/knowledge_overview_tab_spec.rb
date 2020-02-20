require "rails_helper"

RSpec.feature "Knowledge overview tab", type: :feature do
  include_context 'logged in teacher'

  let(:lesson) { FactoryBot.create(:lesson) }
  let!(:lesson_part) { create(:lesson_part, lesson: lesson) }
  let!(:activity) { create(:activity, lesson_part: lesson_part) }

  before { visit(teachers_lesson_path(lesson)) }

  specify 'there should be the correct sections' do
    [
      'Vocabulary',
      'Common misconceptions',
      'Building on previous knowledge',
      'Core knowledge for teachers'
    ].each do |heading|
      expect(page).to have_css('h2', text: heading)
    end
  end

  context 'if there is no previous knowledge' do
    let(:lesson) { FactoryBot.create(:lesson, previous_knowledge: nil) }

    specify 'the previous knowledge section should not be present' do
      expect(page).not_to have_css('h2', text: 'Building on previous knowledge')
    end
  end

  specify 'the page should contain the relevant lesson details' do
    [
      lesson.summary,
      lesson.vocabulary,
      lesson.misconceptions,
      lesson.core_knowledge,
      lesson.previous_knowledge.flatten
    ].flatten.each { |value| expect(page).to have_content(value) }
  end

  specify 'there should be a secondary button link to the lesson contents tab' do
    within('#knowledge-overview') do
      expect(page).to have_link(
        'Lesson contents',
        href: teachers_lesson_path(lesson.id, anchor: 'lesson-contents'),
        class: 'govuk-button--secondary'
      )
    end
  end
end
