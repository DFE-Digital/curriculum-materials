module Teachers
  class LessonsController < BaseController
    before_action :load_resources, only: %i[show print]

    def show; end

    def print
      render layout: 'print'
    end

    private

    def load_resources
      @lesson = Lesson.includes(lesson_parts: { activities: [:teaching_methods] }).find(params[:id])

      @presenter = Teachers::LessonContentsPresenter.new(@lesson, current_teacher)
    end
  end
end
