module Teachers
  class CompleteCurriculumProgrammesController < BaseController
    def index; end

    def show
      file = File.join(Rails.root, 'content', params[:slug], '_index.md')

      @complete_curriculum_programme = CompleteCurriculumProgramme.new
      @complete_curriculum_programme.from_file(file)
    end
  end
end
