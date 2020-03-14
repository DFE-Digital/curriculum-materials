require "rails_helper"

RSpec.describe 'API Token Security', type: :request do
  subject! { get(api_v1_ccps_path) }
  let(:parsed_body) { JSON.parse(response.body) }

  context 'when no token is supplied' do
    specify 'should be unauthorized' do
      expect(response).to be_unauthorized
    end

    specify 'should return an missing token error' do
      expect(parsed_body).to eql('errors' => 'no token supplied')
    end
  end

  context 'when an invalid token is supplied' do
    let(:bad_token) { 'ABC123' }
    subject! { get(api_v1_ccps_path, headers: { Authorization: "Bearer #{bad_token}" }) }

    specify 'should be unauthorized' do
      expect(response).to be_unauthorized
    end

    specify 'should return an invalid token error' do
      expect(parsed_body).to eql('errors' => "bad token Bearer #{bad_token}")
    end
  end
end
