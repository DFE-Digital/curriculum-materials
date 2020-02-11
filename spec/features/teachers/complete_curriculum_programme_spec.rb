require 'rails_helper'

feature 'Complete Curriculum Programme page', type: :feature do
  include_context 'logged in teacher'

  context 'Viewing the page' do
    let(:lesson) { l = Lesson.new; l.from_file(file_fixture("content/year-8-history/roman-history/1-the-battle-of-hastings/_index.md")); l }
    let(:complete_curriculum_programme) { lesson.unit.ccp }
    let(:unit) { lesson.unit }
    let(:units) { complete_curriculum_programme.units }


    before do
      visit complete_curriculum_programme.path
    end

    it "shows the cpp name as the page title" do
      expect(page).to have_css 'h1', text: complete_curriculum_programme.name
    end

    it "contains breadcrumbs with only the current CCP included" do
      within('.govuk-breadcrumbs') do
        expect(page).to have_content(complete_curriculum_programme.name)
      end
    end

    context 'Unit cards' do
      it "shows a card for each unit" do
        units.each do |unit|
          expect(page).to have_css 'h3', text: unit.name
          expect(page).to have_link 'View and plan lessons', href: unit.path
          unit.lessons.each do |lesson|
            expect(page).to have_css('li', text: lesson.name)
          end
        end
      end
    end
  end
end
