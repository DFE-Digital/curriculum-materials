require 'rails_helper'

describe Teachers::CompleteCurriculumProgrammesController, type: :request do
  context '#show' do
    let :complete_curriculum_programme do
      create :complete_curriculum_programme
    end

    subject do
      get teachers_complete_curriculum_programme_path complete_curriculum_programme
    end

    it do
      is_expected.to render_template :show
    end
  end
end
