class CompleteCurriculumProgrammesController < ApplicationController
  def show
    @complete_curriculum_programme = \
      CompleteCurriculumProgramme
        .includes(units: :lessons)
        .find(params[:id])
  end
end
