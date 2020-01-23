class CompleteCurriculumProgramsController < ApplicationController
  def index
    @complete_curriculum_programs = CompleteCurriculumProgram.index
  end

  def show
    @complete_curriculum_program = CompleteCurriculumProgram.show params[:id]
  end
end
