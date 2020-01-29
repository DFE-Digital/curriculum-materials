require 'rails_helper'

describe UnitsController, type: :controller do
  context '#show' do
    let(:unit) { FactoryBot.create(:unit) }
    subject { get :show, params: { id: unit.id } }

    it { is_expected.to render_template :show }
  end
end
