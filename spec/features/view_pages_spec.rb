require "rails_helper"

RSpec.feature "View pages", type: :feature do
  describe 'how-to-get-access' do
    before { visit("/pages/#{subject}") }
    let(:support_email_address) { "curriculum-materials@digital.education.gov.uk" }

    specify 'the page should contain the support email address' do
      expect(page).to have_link(support_email_address, href: "mailto:#{support_email_address}")
    end
  end
end
