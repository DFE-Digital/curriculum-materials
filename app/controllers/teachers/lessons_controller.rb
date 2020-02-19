module Teachers
  class LessonsController < BaseController
    before_action :load_resources, only: %i[show print]

    def show
      @lesson = Lesson.includes(:lesson_parts).find(params[:id])
    end

    def print
      render layout: 'print'
    end

    def load_resources
      @lesson = Lesson.includes(:lesson_parts).find(params[:id])

      @presenter = Teachers::LessonContentsPresenter.new(@lesson, current_teacher)
    end
  end
end
