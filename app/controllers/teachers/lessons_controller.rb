module Teachers
  class LessonsController < BaseController
    def show
      file = File.join(Rails.root, 'content', params[:complete_curriculum_programme_slug], params[:unit_slug], params[:slug], '_index.md')
      @lesson = Lesson.new
      @lesson.from_file(file)

      @lesson_parts = @lesson.parts
    end
  end
end
