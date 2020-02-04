require 'rails_helper'

describe Teachers::SplashesController, type: :request do
  context '#show' do
    subject { get(teachers_splash_path) }

    # the Continue button links to a CCP so at least one
    # needs to exist
    let!(:ccp) { FactoryBot.create(:ccp) }

    it { is_expected.to render_template :show }
  end
end
