module Suppliers
  class CompleteCurriculumProgrammesController < ApplicationController
    layout 'editor'

    def index
      @complete_curriculum_programmes = CompleteCurriculumProgramme.all
    end

    def show
      @complete_curriculum_programme = CompleteCurriculumProgramme.find(params[:id])
    end
  end
end
