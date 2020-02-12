require 'rails_helper'

describe Teachers::UnitsController, type: :request do
  include_context 'logged in teacher'

  context '#show' do
    let(:unit) { u = Unit.new; u.from_file(file_fixture("content/year-8-history/roman-history/_index.md")); u }
    subject { get unit.path }

    it { is_expected.to render_template :show }
  end
end
