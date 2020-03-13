require "rails_helper"

RSpec.feature "Unit page", type: :feature do
  include_context 'logged in teacher'

  describe '#show' do
    let(:number_of_units) { 2 }
    let(:number_of_lessons) { 2 }

    let(:ccp) { create(:ccp, :with_units, number_of_units: number_of_units) }

    let(:unit) do
      create(
        :unit,
        :with_lessons,
        number_of_lessons: number_of_lessons,
        complete_curriculum_programme: ccp
      )
    end

    before { visit(teachers_unit_path(unit)) }

    specify 'the page heading should be the unit title' do
      expect(page).to have_css('h1', text: unit.name)
    end

    specify "there should be breadcrumbs for the CCP and current unit" do
      within('.govuk-breadcrumbs') do
        expect(page).to have_link(ccp.title, href: teachers_complete_curriculum_programme_year_path(ccp, unit.year))
        expect(page).to have_content(unit.name)
      end
    end

    specify %(there should be a table containing this unit's lessons) do
      within('table.units > tbody') do
        expect(page).to have_css('tr.unit', count: number_of_lessons)
      end
    end

    specify 'the table should have the correct headings' do
      within('table.units > thead') do
        ['Lesson number', 'Learning objective', 'Duration'].each do |heading|
          expect(page).to have_css('th', text: heading)
        end
      end
    end

    specify %(the table should contain each lesson's summary) do
      within('table.units > tbody') do
        unit.lessons.map(&:summary).each do |summary|
          expect(page).to have_css('td', text: summary)
        end
      end
    end

    specify 'the table should contain a link to each lesson' do
      within('table.units > tbody') do
        unit.lessons.each do |lesson|
          expect(page).to have_link('View lesson', href: teachers_lesson_path(lesson))
        end
      end
    end

    describe 'navigation side pane' do
      specify 'there should be a side pane containing a navigation list' do
        expect(page).to have_css('nav.siblings')
      end

      let(:other_units) { ccp.units.reject { |u| u.eql?(unit) } }

      specify 'the current unit should be marked appropriately' do
        within('nav.siblings') do
          expect(page).to have_css('li.current', text: unit.name)
        end
      end

      xspecify 'there should be a  navigation list containing other units in the CCP' do
        within('nav.siblings') do
          other_units.each do |unit|
            expect(page).to have_link(unit.name, href: teachers_unit_path(unit))
          end
        end
      end
    end
  end
end
