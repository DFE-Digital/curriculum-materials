module Teachers
  class ActivityChoicesController < BaseController
    before_action :set_lesson_part_and_activities

    def new
      @activity_choice = ActivityChoice.new
    end

    def create
      @activity_choice = @lesson_part.activity_choices.new(activity_choice_params.merge(teacher: current_teacher))

      if @activity_choice.save
        redirect_to teachers_lesson_path(@lesson_part.lesson_id, anchor: 'lesson-contents')
      else
        render :new
      end
    end

    def edit
      @activity_choice = ActivityChoice.find_by(lesson_part: @lesson_part, teacher: current_teacher)
    end

    def update
      @activity_choice = ActivityChoice.find_by(lesson_part: @lesson_part, teacher: current_teacher)

      if @activity_choice.update(activity_choice_params)
        redirect_to teachers_lesson_path(@lesson_part.lesson_id, anchor: 'lesson-contents')
      else
        render :edit
      end
    end

  private

    def set_lesson_part_and_activities
      @lesson_part = LessonPart.find(params[:lesson_part_id])
      @activities = @lesson_part.activities
    end

    def activity_choice_params
      params.require(:activity_choice).permit(:activity_id)
    end
  end
end
