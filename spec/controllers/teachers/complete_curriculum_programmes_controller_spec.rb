require 'rails_helper'

describe Teachers::CompleteCurriculumProgrammesController, type: :request do
  include_context 'logged in teacher'

  context '#index' do
    let! :complete_curriculum_programmes do
      create_list :complete_curriculum_programme, 2
    end

    subject do
      get teachers_complete_curriculum_programmes_path
    end

    it do
      is_expected.to render_template :index
    end
  end
end
