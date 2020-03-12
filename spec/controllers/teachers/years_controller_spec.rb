require 'rails_helper'

describe Teachers::YearsController , type: :request do
  include_context 'logged in teacher'

  context '#show' do
    let(:unit) { FactoryBot.create(:unit) }
    let(:ccp) { unit.complete_curriculum_programme }

    subject { get teachers_complete_curriculum_programme_year_path(ccp.id, unit.year) }

    it { is_expected.to render_template(:show) }
  end
end
