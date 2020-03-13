require "rails_helper"

RSpec.describe Api::BaseController, type: :request do
  subject! { get(api_v1_ccps_path) }

  specify 'should be unauthorized' do
    expect(response).to be_unauthorized
  end
end
