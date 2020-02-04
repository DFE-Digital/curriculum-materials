require "rails_helper"

RSpec.describe Teachers::HomesController, type: :request do
  include_context 'logged in teacher'

  describe '#show' do
    subject { get(teachers_home_path) }

    specify 'should render the show template' do
      expect(subject).to render_template(:show)
    end
  end
end
