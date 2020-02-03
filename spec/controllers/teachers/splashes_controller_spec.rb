require 'rails_helper'

describe Teachers::SplashesController, type: :controller do
  context '#show' do
    subject { get :show }

    it { is_expected.to render_template :show }
  end
end
