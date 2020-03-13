require "rails_helper"

RSpec.feature "Home page", type: :feature do
  include_context 'logged in teacher'

  describe '#show' do
    before do
      visit('/')
    end

    specify 'the page should have the correct heading' do
      expect(page).to have_css('h1', text: 'Access curriculum resources')
    end

    specify "there should be a 'Start now' button" do
      expect(page).to have_link('Start now', href: '/teachers/splash')
    end
  end
end
