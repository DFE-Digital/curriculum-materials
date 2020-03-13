module Teachers
  class YearsController < BaseController
    def show
      @complete_curriculum_programme = CompleteCurriculumProgramme.find(params[:complete_curriculum_programme_id])
      @units = @complete_curriculum_programme.units.eager_load(:lessons).at_year(params[:id])
    end
  end
end
