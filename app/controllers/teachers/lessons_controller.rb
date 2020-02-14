module Teachers
  class LessonsController < BaseController
    def show
      @lesson = Lesson.eager_load(lesson_parts: :activities).find(params[:id])

      # We only want the 'active' activities here; those that have been
      # selected by the current teacher or, if no selection has been made, the
      # default.
      # FIXME optimise the query
      @lesson_contents = @lesson
        .lesson_parts
        .each_with_object({}) do |lp, hash|
          hash[lp] = lp.activity_for(current_teacher)
        end
    end
  end
end
