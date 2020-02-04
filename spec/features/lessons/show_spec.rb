require "rails_helper"

RSpec.feature "Lesson page", type: :feature do
  include_context 'logged in teacher'

  describe '#show' do
    let(:lesson) { FactoryBot.create(:lesson) }
    let(:unit) { lesson.unit }
    let(:ccp) { unit.complete_curriculum_programme }

    before { visit(teachers_lesson_path(lesson)) }

    specify 'the page heading should be the lesson title' do
      expect(page).to have_css('h1', text: lesson.name)
    end

    specify "there should be breadcrumbs for the CCP and current unit" do
      within('.govuk-breadcrumbs') do
        expect(page).to have_link(ccp.name, href: teachers_complete_curriculum_programme_path(ccp))
        expect(page).to have_link(unit.name, href: teachers_unit_path(unit))
        expect(page).to have_content(lesson.name)
      end
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
