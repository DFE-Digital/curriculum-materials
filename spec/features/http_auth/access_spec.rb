require 'rails_helper'

RSpec.describe 'HTTP Auth for the staging environment', type: :feature do
  include_context 'logged in teacher'

  describe 'accessing the site' do
    context 'when the environment is staging' do
      before do
        allow(Rails.env).to receive(:staging?).and_return(true)
      end

      context 'when no credentials are provided' do
        before { visit('/') }

        specify 'should return 401: unauthorized and prompt the user for credentials' do
          expect(page).to have_http_status(:unauthorized)
        end
      end

      context 'when credentials are provided' do
        let(:username) { 'nelsonmuntz' }
        let(:password) { 'ha-ha' }

        before do
          allow(ENV).to receive(:fetch).with('HTTP_AUTH_USER').and_return(username)
          allow(ENV).to receive(:fetch).with('HTTP_AUTH_PASSWORD').and_return(password)
        end

        let(:credentials) do
          ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
        end

        before do
          page.driver.header 'Authorization', credentials
        end

        before { visit('/') }

        specify 'should prompt for auth when requesting the landing page' do
          expect(page).to have_http_status(:ok)
        end
      end
    end

    context 'when the environment is not staging' do
      before do
        allow(Rails.env).to receive(:staging?).and_return(false)
      end

      before { visit('/') }

      specify 'should allow access' do
        expect(page).to have_http_status(:ok)
      end
    end
  end
end
