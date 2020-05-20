module Suppliers
  class CompleteCurriculumProgrammesController < ApplicationController
    layout 'editor', except: :index

    def index
      @complete_curriculum_programmes = CompleteCurriculumProgramme.all
    end

    def show
      @ccp = CompleteCurriculumProgramme.find(params[:id])
    end
  end
end
