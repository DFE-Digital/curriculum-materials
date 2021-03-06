shared_context 'setup api token' do
  let(:api_token) { 'ABC123' }
  let(:Authorization) { "Bearer #{api_token}" }
  before { allow(ENV).to receive(:fetch).with('API_TOKEN').and_return(api_token) }
end

shared_examples 'an endpoint that requires token auth' do
  context 'when no token is supplied' do
    let!(:Authorization) { nil }

    run_test! do |response|
      expect(JSON.parse(response.body).dig('errors')).to include(%(no token supplied))
    end
  end

  context 'when a bad token is supplied' do
    let(:bad_token) { 'bad_t0k3n' }
    let!(:Authorization) { bad_token }

    run_test! do |response|
      expect(JSON.parse(response.body).dig('errors')).to include(%(bad token #{bad_token}))
    end
  end
end
