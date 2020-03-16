module Teachers
  class CompleteCurriculumProgrammesController < BaseController
    def index
      @complete_curriculum_programmes = CompleteCurriculumProgramme.all
    end

    def show
      @complete_curriculum_programme = \
        CompleteCurriculumProgramme
          .includes(units: :lessons)
          .find(params[:id])
    end
  end
end
