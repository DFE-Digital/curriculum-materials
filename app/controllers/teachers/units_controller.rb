module Teachers
  class UnitsController < BaseController
    def show
      file = File.join(Rails.root, 'content', params[:complete_curriculum_programme_slug], params[:slug], '_index.md')

      @unit = Unit.new
      @unit.from_file(file)
    end
  end
end
