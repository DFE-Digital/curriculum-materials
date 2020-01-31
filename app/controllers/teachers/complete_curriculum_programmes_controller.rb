module Teachers
  class CompleteCurriculumProgrammesController < BaseController
    def index; end

    def show
      @complete_curriculum_programme = \
        CompleteCurriculumProgramme
          .includes(units: :lessons)
          .find(params[:id])
    end
  end
end
