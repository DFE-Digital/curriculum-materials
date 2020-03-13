shared_context 'setup api token' do
  let(:api_token) { 'ABC123' }
  let!(:HTTP_API_TOKEN) { api_token }
  before { allow(ENV).to receive(:fetch).with('API_TOKEN').and_return(api_token) }
end
