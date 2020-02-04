require "rails_helper"

RSpec.feature "Logging out", type: :feature do
  context 'when I am logged in' do
    include_context 'logged in teacher'

    before { visit(teachers_home_path) }

    specify 'there should be a logout link in the phase bar' do
      within('.govuk-phase-banner') do
        expect(page).to have_link('Log out', href: teachers_session_path)
      end
    end

    specify 'actually logging out' do
      click_link 'Log out'
      expect(page.current_path).to eql(teachers_session_path)

      click_button 'Log out'
      expect(page.current_path).to eql(teachers_logged_out_path)

      # ensure we are now denied entry and redirected to guidance page instead
      visit(teachers_home_path)
      expect(page.current_path).to eql('/pages/how-to-get-access')
    end
  end
end
