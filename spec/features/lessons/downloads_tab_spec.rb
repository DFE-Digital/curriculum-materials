require "rails_helper"

RSpec.feature "Downloads tab", type: :feature do
  include_context 'logged in teacher'

  let(:lesson) { FactoryBot.create(:lesson) }

  before { visit(teachers_lesson_path(lesson)) }

  specify %(the tab's main heading should be 'Downloads') do
    within('#downloads') { expect(page).to have_css('h2', text: 'Downloads') }
  end

  specify %(there should be a 'Print lesson plan' link) do
    within('#downloads') { expect(page).to have_link('Print lesson plan') }
  end

  specify %(there should be a 'Download teacher resources' link) do
    within('#downloads') { expect(page).to have_link('Download teacher resources') }
  end

  specify %(there should be a 'Download pupil resources' link) do
    within('#downloads') { expect(page).to have_link('Download pupil resources') }
  end

  specify %(there should be a 'Plan the next lesson' button) do
    expect(page).to have_link('Plan the next lesson', href: '#', class: 'govuk-button')
  end
end
