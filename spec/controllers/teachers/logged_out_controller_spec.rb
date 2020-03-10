require "rails_helper"

RSpec.describe Teachers::LoggedOutController, type: :request do
  describe '#show' do
    let(:token) { 'abc123' }

    subject { get(teachers_logged_out_path(token: token)) }

    specify 'should render the show template' do
      expect(subject).to render_template(:show)
    end

    specify 'the page has a link to log back in' do
      subject

      page = Capybara::Node::Simple.new response.body

      expect(page).to have_link 'Log in', href: "/teachers/session/#{token}"
    end
  end
end
