require 'rails_helper'

feature 'Complete Curriculum Programme page', type: :feature do
  context 'Viewing the page' do
    let! :complete_curriculum_programme do
      create :complete_curriculum_programme
    end

    let! :units do
      create_list \
        :unit, 6, complete_curriculum_programme: complete_curriculum_programme
    end

    before do
      units.each do |unit|
        create_list :lesson, 6, unit: unit
      end
    end

    before do
      visit "/teachers/complete_curriculum_programmes/#{complete_curriculum_programme.id}"
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
          expect(page).to have_link 'View and plan lessons', href: teachers_unit_path(unit)
          unit.lessons.each do |lesson|
            expect(page).to have_css('li', text: lesson.name)
          end
        end
      end
    end
  end
end
