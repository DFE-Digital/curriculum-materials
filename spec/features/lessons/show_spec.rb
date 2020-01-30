require "rails_helper"

RSpec.feature "Lesson page", type: :feature do
  describe '#show' do
    let(:lesson) { FactoryBot.create(:lesson) }

    before { visit(lesson_path(lesson)) }

    specify 'the page heading should be the lesson title' do
      expect(page).to have_css('h1', text: lesson.name)
    end

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

    specify 'the page should contain the relevant lesson details' do
      [
        lesson.summary,
        lesson.vocabulary,
        lesson.misconceptions,
        lesson.core_knowledge
      ].flatten.each { |value| expect(page).to have_content(value) }
    end

    specify %(there should be a 'Plan the next lesosn' button) do
      expect(page).to have_link('Plan the next lesson', href: '#', class: 'govuk-button')
    end
  end
end
