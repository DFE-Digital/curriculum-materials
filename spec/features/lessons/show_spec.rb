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

    specify 'the lesson duration should be detailed in a caption' do
      expect(page).to have_css('.govuk-caption-m', text: lesson.duration)
    end

    specify "there should be breadcrumbs for the CCP and current unit" do
      within('.govuk-breadcrumbs') do
        expect(page).to have_link(ccp.title, href: teachers_complete_curriculum_programme_year_path(ccp, unit.year))
        expect(page).to have_link(unit.name, href: teachers_unit_path(unit))
        expect(page).to have_content(lesson.name)
      end
    end
  end
end
