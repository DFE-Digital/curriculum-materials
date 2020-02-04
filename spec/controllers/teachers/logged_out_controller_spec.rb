require "rails_helper"

RSpec.describe Teachers::LoggedOutController, type: :request do
  describe '#show' do
    subject { get(teachers_logged_out_path) }

    specify 'should render the show template' do
      expect(subject).to render_template(:show)
    end
  end
end
