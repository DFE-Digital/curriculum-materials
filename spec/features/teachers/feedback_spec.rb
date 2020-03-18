require "rails_helper"

RSpec.feature "Emailing feedback", type: :feature do
  let(:email_address) { 'curriculum-materials@digital.education.gov.uk' }
  include_context 'logged in teacher'

  before { visit(teachers_home_path) }

  specify 'there should be a feedback email link in the phase banner' do
    within('.govuk-phase-banner') do
      expect(page).to have_link('feedback', href: "mailto:" + email_address)
    end
  end
end
