module Teachers
  class LessonsController < BaseController
    def show
      @lesson = Lesson.includes(
        lesson_parts: { default_activity: nil, activities: [:teaching_methods] }
      ).find(params[:id])

      @presenter = Teachers::LessonContentsPresenter.new(@lesson, current_teacher)
    end
  end
end
