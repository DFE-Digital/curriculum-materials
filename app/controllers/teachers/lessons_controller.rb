module Teachers
  class LessonsController < BaseController
    def show
      file = File.join(Rails.root, 'content', params[:complete_curriculum_programme_slug], params[:unit_slug], params[:slug], '_index.md')
      @lesson = Lesson.from_file(file)
      @lesson_parts = @lesson.parts_for_teacher(current_teacher)
    end

    def change_activity
      file = File.join(Rails.root, 'content', params[:complete_curriculum_programme_slug], params[:unit_slug], params[:lesson_slug], '_index.md')
      @lesson = Lesson.from_file(file)

      # TODO check record to delete old subsitution
      choice_params = {
        activity_number: params[:activity_number],
        lesson_slug: params[:lesson_slug],
        unit_slug: params[:unit_slug],
        complete_curriculum_programme_slug: params[:complete_curriculum_programme_slug],
      }
      choice = current_teacher.activity_choices.find_by(choice_params)
      if choice.present?
        choice.update!(activity_slug: params[:activity_slug])
      else
        current_teacher.activity_choices.create!(choice_params.merge(activity_slug: params[:activity_slug]))
      end
      redirect_to @lesson.path, anchor: "lesson-contents"
    end
  end
end
