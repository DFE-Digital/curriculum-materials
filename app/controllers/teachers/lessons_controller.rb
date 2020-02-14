module Teachers
  class LessonsController < BaseController
    def show
      @lesson = Lesson.eager_load(lesson_parts: :activities).find(params[:id])

      # We only want the 'active' activities here; those that have been
      # selected by the current teacher or, if no selection has been made, the
      # default.
      # FIXME optimise the query
      @activities = @lesson.lesson_parts.map { |lp| lp.activity_for(current_teacher) }
    end
  end
end
