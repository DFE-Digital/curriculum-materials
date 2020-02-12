require 'rails_helper'

describe Teachers::CompleteCurriculumProgrammesController, type: :request do
  include_context 'logged in teacher'

  context '#show' do
    let(:complete_curriculum_programme) do
      c = CompleteCurriculumProgramme.new;
      c.from_file(file_fixture("content/year-8-history/_index.md"));
      c
    end

    subject do
      get teachers_complete_curriculum_programme_path complete_curriculum_programme
    end

    it do
      is_expected.to render_template :show
    end
  end
end
