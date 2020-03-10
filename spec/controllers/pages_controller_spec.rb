require 'rails_helper'

describe PagesController, type: :request do
  context '#show' do
    context 'when page is found' do
      subject { get "/pages/#{page}" }

      let(:page) { 'how-to-get-access' }

      it { is_expected.to render_template page }
    end

    context 'when page is not found' do
      let(:page) { 'non-existent-page' }

      it "throws a 404 error" do
        expect { get "/pages/#{page}" }.to raise_error \
          ActionController::RoutingError
      end
    end
  end
end
