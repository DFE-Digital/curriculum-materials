require 'rails_helper'

describe Teachers::UnitsController, type: :request do
  context '#show' do
    let(:unit) { FactoryBot.create(:unit) }
    subject { get teachers_unit_path(unit) }

    it { is_expected.to render_template :show }
  end
end
