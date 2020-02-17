module Teachers
  class ActivityChoicesController < BaseController
    before_action :load_resources

    def new
      @activity_choice = ActivityChoice.new
    end

    def create
      @activity_choice = current_teacher
        .activity_choices
        .new(activity_choice_params.merge(lesson_part: @lesson_part))

      if @activity_choice.save
        redirect_to teachers_lesson_path(@lesson_part.lesson_id, anchor: 'lesson-contents')
      else
        render :new
      end
    end

    def edit
      @activity_choice = current_teacher
        .activity_choices
        .find_by!(lesson_part: @lesson_part)
    end

    def update
      @activity_choice = current_teacher
        .activity_choices
        .find_by!(lesson_part: @lesson_part)

      if @activity_choice.update(activity_choice_params)
        redirect_to teachers_lesson_path(@lesson_part.lesson_id, anchor: 'lesson-contents')
      else
        render :edit
      end
    end

  private

    def load_resources
      @lesson_part = LessonPart.eager_load(:lesson).find(params[:lesson_part_id])
      @lesson = @lesson_part.lesson
      @activities = @lesson_part.activities
    end

    def activity_choice_params
      params.require(:activity_choice).permit(:activity_id)
    end
  end
end
