require 'rails_helper'

describe Teachers::SplashesController, type: :request do
  context '#show' do
    # let(:complete_curriculum_programme) { c = CompleteCurriculumProgramme.new; c.from_file(file_fixture("content/year-8-history/_index.md")); c }
    subject { get(teachers_splash_path) }

    # the Continue button links to a CCP so at least one
    # needs to exist

    it { is_expected.to render_template :show }
  end
end
