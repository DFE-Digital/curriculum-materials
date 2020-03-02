module Teachers
  class LessonsController < BaseController
    before_action :load_resources, only: %i[show print]

    def show
      @lesson = Lesson.includes(:lesson_parts).find(params[:id])
    end

    def print
      render layout: 'print'
    end

  private

    def load_resources
      @lesson = Lesson
        .eager_load(lesson_parts: { activities: [:activity_choices, :teaching_methods, { activity_teaching_methods: :teaching_method }] })
        .merge(LessonPart.ordered_by_position)
        .find(params[:id])

      @presenter = Teachers::LessonContentsPresenter.new(@lesson, current_teacher)
    end
  end
end
