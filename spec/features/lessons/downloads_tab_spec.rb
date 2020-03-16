require "rails_helper"

RSpec.feature "Downloads tab", type: :feature do
  include_context 'logged in teacher'

  let(:lesson) { FactoryBot.create(:lesson) }

  before { visit(teachers_lesson_path(lesson)) }

  specify %(the tab's main heading should be 'Download the lesson plan and resources') do
    within('#downloads') { expect(page).to have_css('h2', text: 'Download the lesson plan and resources') }
  end

  specify %(there should be a 'Print lesson plan' link) do
    within('#downloads') { expect(page).to have_link('Print lesson plan') }
  end

  specify %(there should be a 'Download lesson resources' button) do
    within('#downloads') { expect(page).to have_button('Download lesson resources') }
  end

  specify %(there should be a 'Go to next lesson' link) do
    expect(page).to \
      have_link('Go to next lesson', href: teachers_unit_path(lesson.unit))
  end

  context 'Download lesson resources' do
    before do
      click_button 'Download lesson resources'
    end

    specify "it should redirect to the download page" do
      expect(page.current_path).to eq \
        teachers_download_path(teacher.downloads.last)
    end
  end

  context 'Print lesson plan' do
    before do
      click_link 'Print lesson plan'
    end

    specify "it should redirect to the print lesson page" do
      expect(page.current_path).to eq print_teachers_lesson_path(lesson)
    end
  end
end
