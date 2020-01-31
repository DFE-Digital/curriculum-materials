require "rails_helper"

RSpec.describe Teachers::HomesController, type: :controller do
  describe '#show' do
    subject { get(:show) }

    specify 'should render the show template' do
      expect(subject).to render_template(:show)
    end
  end
end
